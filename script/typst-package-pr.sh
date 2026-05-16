#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: typst-package-pr.sh [options]

Prepare a Typst official packages PR for the version in typst.toml.

Options:
  --dry-run                 Generate and validate package files without git push or PR creation.
  --create-pr               Create the GitHub PR after pushing the branch.
  --create-pr-only          Create the GitHub PR from an existing pushed branch and pr-body.md.
  --pr-reviewed             Required with --create-pr or --create-pr-only after human review.
  --allow-dirty             Allow a dirty source repo. Use only for intentional local validation.
  --force-workdir           Remove an existing temporary workdir before starting.
  --workdir <path>          Workdir to use. Defaults to /tmp/typst-packages-<name>-<version>.
  --fork <repo-url>         Fork remote. Defaults to git@github.com:golixp/typst-official-packages-repo.git.
  --fork-owner <owner>      GitHub owner for PR head. Defaults to golixp.
  --upstream <repo-url>     Upstream remote. Defaults to git@github.com:typst/packages.
  --change-summary <text>   Human-readable update summary for the PR body.
  --ai-tool-model <text>    AI disclosure text, including tool and exact model.
  -h, --help                Show this help.

Default behavior prepares, validates, commits, and pushes the PR branch, then prints
the PR title and body. After human review, use --create-pr-only --pr-reviewed to
open the PR without regenerating the release commit.
EOF
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

read_toml_string() {
  local key="$1"
  awk -F '=' -v key="$key" '
    $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
      value = $2
      sub(/^[[:space:]]*"/, "", value)
      sub(/"[[:space:]]*$/, "", value)
      print value
      exit
    }
  ' typst.toml
}

PACKAGE_NAME="$(read_toml_string name)"
PACKAGE_VERSION="$(read_toml_string version)"

if [[ -z "$PACKAGE_NAME" || -z "$PACKAGE_VERSION" ]]; then
  echo "error: unable to read package name/version from typst.toml" >&2
  exit 1
fi

DRY_RUN=0
CREATE_PR=0
CREATE_PR_ONLY=0
PR_REVIEWED=0
ALLOW_DIRTY=0
FORCE_WORKDIR=0
FORK_REPO="git@github.com:golixp/typst-official-packages-repo.git"
FORK_OWNER="golixp"
UPSTREAM_REPO="git@github.com:typst/packages"
WORKDIR="/tmp/typst-packages-${PACKAGE_NAME}-${PACKAGE_VERSION}"
CHANGE_SUMMARY="Update ${PACKAGE_NAME} to ${PACKAGE_VERSION}."
AI_TOOL_MODEL="OpenAI Codex, model confirmed by the current release session"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --create-pr)
      CREATE_PR=1
      shift
      ;;
    --create-pr-only)
      CREATE_PR_ONLY=1
      shift
      ;;
    --pr-reviewed)
      PR_REVIEWED=1
      shift
      ;;
    --allow-dirty)
      ALLOW_DIRTY=1
      shift
      ;;
    --force-workdir)
      FORCE_WORKDIR=1
      shift
      ;;
    --workdir|--fork|--fork-owner|--upstream|--change-summary|--ai-tool-model)
      if [[ $# -lt 2 ]]; then
        echo "error: $1 requires a value" >&2
        exit 1
      fi
      case "$1" in
        --workdir) WORKDIR="$2" ;;
        --fork) FORK_REPO="$2" ;;
        --fork-owner) FORK_OWNER="$2" ;;
        --upstream) UPSTREAM_REPO="$2" ;;
        --change-summary) CHANGE_SUMMARY="$2" ;;
        --ai-tool-model) AI_TOOL_MODEL="$2" ;;
      esac
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$CREATE_PR" -eq 1 && "$CREATE_PR_ONLY" -eq 1 ]]; then
  echo "error: use either --create-pr or --create-pr-only, not both" >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 1 && "$CREATE_PR_ONLY" -eq 1 ]]; then
  echo "error: --dry-run cannot be combined with --create-pr-only" >&2
  exit 1
fi

if [[ "$CREATE_PR" -eq 1 && "$PR_REVIEWED" -ne 1 ]]; then
  echo "error: --create-pr requires --pr-reviewed after the PR body was shown to a human" >&2
  exit 1
fi

if [[ "$CREATE_PR_ONLY" -eq 1 && "$PR_REVIEWED" -ne 1 ]]; then
  echo "error: --create-pr-only requires --pr-reviewed after the PR body was shown to a human" >&2
  exit 1
fi

if [[ "$CREATE_PR" -eq 1 || "$CREATE_PR_ONLY" -eq 1 ]] && ! command -v gh >/dev/null 2>&1; then
  echo "error: gh is required when --create-pr is used" >&2
  exit 1
fi

BRANCH="v${PACKAGE_VERSION}"
PACKAGE_PATH="packages/preview/${PACKAGE_NAME}/${PACKAGE_VERSION}"
PR_TITLE="${PACKAGE_NAME}:${PACKAGE_VERSION}"
PR_BODY_FILE="${WORKDIR}/pr-body.md"

if [[ "$CREATE_PR_ONLY" -eq 1 ]]; then
  if [[ ! -f "$PR_BODY_FILE" ]]; then
    echo "error: PR body file not found: $PR_BODY_FILE" >&2
    echo "Run this script without --create-pr-only first to prepare and push the branch." >&2
    exit 1
  fi
  echo "PR title:"
  echo "$PR_TITLE"
  echo
  echo "PR body:"
  cat "$PR_BODY_FILE"
  echo
  gh pr create \
    --repo typst/packages \
    --base main \
    --head "${FORK_OWNER}:${BRANCH}" \
    --title "$PR_TITLE" \
    --body-file "$PR_BODY_FILE"
  exit 0
fi

for command in git typst; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "error: required command not found: $command" >&2
    exit 1
  fi
done

SOURCE_STATUS="$(git status --porcelain)"
if [[ -n "$SOURCE_STATUS" && "$ALLOW_DIRTY" -ne 1 ]]; then
  echo "error: source repository has uncommitted changes" >&2
  echo "$SOURCE_STATUS" >&2
  exit 1
elif [[ -n "$SOURCE_STATUS" ]]; then
  echo "warning: source repository has uncommitted changes; continuing because --allow-dirty was provided" >&2
fi

if [[ -e "$WORKDIR" ]]; then
  if [[ "$FORCE_WORKDIR" -ne 1 ]]; then
    echo "error: workdir already exists: $WORKDIR" >&2
    echo "Use --force-workdir to remove it first." >&2
    exit 1
  fi
  rm -rf "$WORKDIR"
fi

echo "Validating source package..."
typst compile example.typ "/tmp/${PACKAGE_NAME}-example.pdf"
typst compile -f png --pages 1 --ppi 300 example.typ "/tmp/${PACKAGE_NAME}-thumbnail.png"

if [[ "$DRY_RUN" -eq 1 ]]; then
  mkdir -p "$WORKDIR"
else
  git clone --depth 1 --no-checkout --filter=tree:0 "$FORK_REPO" "$WORKDIR"
  cd "$WORKDIR"
  git sparse-checkout init
  git sparse-checkout set "packages/preview/${PACKAGE_NAME}"
  git remote add upstream "$UPSTREAM_REPO"
  git config remote.upstream.partialclonefilter tree:0
  git fetch upstream main --depth=1
  git checkout -b "$BRANCH" upstream/main
  cd "$ROOT_DIR"
fi

bash "$ROOT_DIR/script/publish.sh" "${WORKDIR}/${PACKAGE_PATH}"

echo "Validating generated package..."
typst compile \
  --package-path "${WORKDIR}/packages" \
  "${WORKDIR}/${PACKAGE_PATH}/template/main.typ" \
  "/tmp/${PACKAGE_NAME}-package-template.pdf"

mkdir -p "$(dirname "$PR_BODY_FILE")"
cat > "$PR_BODY_FILE" <<EOF
I am submitting
- [ ] a new package
- [x] an update for a package

Description: Patch release for \`${PACKAGE_NAME}\`.

${CHANGE_SUMMARY}

Validation:
- \`typst compile example.typ /tmp/${PACKAGE_NAME}-example.pdf\`
- \`typst compile -f png --pages 1 --ppi 300 example.typ /tmp/${PACKAGE_NAME}-thumbnail.png\`
- \`typst compile --package-path ${WORKDIR}/packages ${WORKDIR}/${PACKAGE_PATH}/template/main.typ /tmp/${PACKAGE_NAME}-package-template.pdf\`

AI assistance disclosure:
This package update and PR preparation were assisted by ${AI_TOOL_MODEL}. The package contents, generated release files, validation steps, and PR description were reviewed by the human package author before submission.
EOF

if [[ "$DRY_RUN" -ne 1 ]]; then
  cd "$WORKDIR"
  git add "$PACKAGE_PATH"
  git commit -m "$PR_TITLE"
  git push origin "$BRANCH"
fi

echo
echo "PR title:"
echo "$PR_TITLE"
echo
echo "PR body:"
cat "$PR_BODY_FILE"
echo

if [[ "$CREATE_PR" -eq 1 ]]; then
  cd "$WORKDIR"
  gh pr create \
    --repo typst/packages \
    --base main \
    --head "${FORK_OWNER}:${BRANCH}" \
    --title "$PR_TITLE" \
    --body-file "$PR_BODY_FILE"
elif [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete; no branch was pushed and no PR can be created from this workdir."
else
  echo "After human review, create the PR with:"
  echo "  bash $ROOT_DIR/script/typst-package-pr.sh --create-pr-only --pr-reviewed --workdir $WORKDIR --fork-owner $FORK_OWNER"
fi
