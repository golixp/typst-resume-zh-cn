#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
用法: publish.sh [--force] <目标目录>

将当前仓库内容生成 Typst 官方包目录。
目标目录必须以 /<package-name>/<version> 结尾，例如:
  packages/preview/golixp-resume-zh-cn/<version>

选项:
  --force   删除并重新生成已存在的目标版本目录。
EOF
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

FORCE=0
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "错误: 未知选项 $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$TARGET_DIR" ]]; then
        echo "错误: 只能指定一个目标目录" >&2
        usage >&2
        exit 1
      fi
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  usage >&2
  exit 1
fi

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
  echo "错误: 无法从 typst.toml 读取 package name/version" >&2
  exit 1
fi

TARGET_DIR="${TARGET_DIR%/}"
TARGET_VERSION="$(basename "$TARGET_DIR")"
TARGET_PACKAGE="$(basename "$(dirname "$TARGET_DIR")")"

if [[ "$TARGET_PACKAGE" != "$PACKAGE_NAME" || "$TARGET_VERSION" != "$PACKAGE_VERSION" ]]; then
  echo "错误: 目标目录必须以 /$PACKAGE_NAME/$PACKAGE_VERSION 结尾" >&2
  echo "当前目标目录: $TARGET_DIR" >&2
  exit 1
fi

if [[ -e "$TARGET_DIR" ]]; then
  if [[ "$FORCE" -ne 1 ]]; then
    echo "错误: 目标目录已存在: $TARGET_DIR" >&2
    echo "如需重新生成，请使用 --force。" >&2
    exit 1
  fi
  rm -rf "$TARGET_DIR"
fi

# 创建目标目录
mkdir -p "$TARGET_DIR"

# 需要复制的文件和目录
ITEMS=(
  "LICENSE"
  "README.md"
  "typst.toml"
  "modules"
  "template"
  "lib.typ"
)

for item in "${ITEMS[@]}"; do
  if [[ -e "$item" ]]; then
    cp -r "$item" "$TARGET_DIR/"
  else
    echo "警告: 未找到 $item，跳过"
  fi
done

# 生成拼接后的 README（中文在前）
ZH_SRC="$ROOT_DIR/README.md"
EN_SRC="$ROOT_DIR/README_en.md"
MERGED_README="$TARGET_DIR/README.md"

if [[ -f "$ZH_SRC" && -f "$EN_SRC" ]]; then
  tmp_zh_src="$(mktemp)"
  tmp_en_src="$(mktemp)"
  tmp_zh="$(mktemp)"
  tmp_en="$(mktemp)"

  strip_maintainer_section() {
    local heading="$1"
    awk -v heading="$heading" '
      $0 == heading {
        skip = 1
        next
      }
      skip && /^## / {
        skip = 0
      }
      !skip {
        print
      }
    '
  }

  # 仓库 README 包含维护者发布说明；官方包 README 只保留用户文档。
  strip_maintainer_section "## 维护者：发布到 Typst Packages" < "$ZH_SRC" > "$tmp_zh_src"
  strip_maintainer_section "## Maintainers: Publish to Typst Packages" < "$EN_SRC" > "$tmp_en_src"

  # 处理中文 README:
  # 1. 在标题后增加中文锚点
  # 2. 将第 3 行修改为单文件内跳转
  awk '
    NR == 1 {
      print "<a id=\"zh\"></a>"
      print $0
      next
    }
    NR == 3 {
      print "[中文](#zh) | [English](#en)"
      next
    }
    { print }
  ' "$tmp_zh_src" > "$tmp_zh"

  # 处理英文 README:
  # 1. 在标题后增加英文锚点
  # 2. 将第 3 行修改为单文件内跳转
  awk '
    NR == 1 {
      print "<a id=\"en\"></a>"
      print $0
      next
    }
    NR == 3 {
      print "[中文](#zh) | [English](#en)"
      next
    }
    { print }
  ' "$tmp_en_src" > "$tmp_en"

  # 中文在前，英文在后
  cat "$tmp_zh" "$tmp_en" > "$MERGED_README"

  rm -f "$tmp_zh_src" "$tmp_en_src" "$tmp_zh" "$tmp_en"
else
  echo "警告: 未找到 README.md 或 README_en.md，跳过 README 拼接"
fi

# 在项目根目录编译缩略图到目标目录
if ! command -v typst >/dev/null 2>&1; then
  echo "错误: 未找到 typst 命令，请先安装 Typst。"
  exit 1
fi

typst compile -f png --pages 1 --ppi 300 example.typ "$TARGET_DIR/thumbnail.png"

echo "Typst 包已生成到: $TARGET_DIR"
