---
name: typst-package-release
description: 当需要把当前仓库作为 golixp-resume-zh-cn Typst 官方包的新版本发布到 typst/packages 时使用本 skill。它指导 AI 完成官方规范复核、包目录生成、本地验证、带 AI 声明的 PR 文案人工确认、分支推送、PR 创建和 CI 跟进。
---

# Typst 官方包发布

## 概览

本 skill 用于通过 Pull Request 将当前仓库发布到官方 `typst/packages` registry。它面向 AI 辅助发布场景：维护者会显式提供这个 skill 路径，AI 按这里的流程执行。

准备 PR 前先阅读 `references/typst-package-guidelines.md`。每次发布都要重新核对官方上游文档，因为包发布规则可能变化。

## 发布流程

1. **确认当前事实**
   - 在源仓库运行 `git status --short --branch`。
   - 从 `typst.toml` 读取 `package.name` 和 `package.version`。
   - 查看最近提交，理解这次面向用户的变更。
   - 如果要创建 PR，先确认 `gh auth status` 可用。

2. **刷新官方规则**
   - 用 web 或 `gh api` 读取当前 `typst/packages` README、PR 模板和相关文档。
   - 搜索是否出现 AI 生成或 AI 辅助提交的新政策。
   - 如果新规则和本流程冲突，停止并说明冲突。

3. **准备源仓库发布状态**
   - 确认 README 示例、`template/main.typ`、`example.typ`、`script/pr.sh` 和 `typst.toml` 都使用目标版本。
   - 先提交并推送源仓库的发布变更，再准备官方包仓库分支。
   - 除非维护者明确要求发布 GitHub Release，不要创建 git tag。

4. **生成并验证包目录**
   - 优先使用 `script/typst-package-pr.sh`，让发布路径尽量确定。
   - 先用全新的 `/tmp` 工作目录运行 `--dry-run --force-workdir`。
   - 确认生成的官方包目录只包含预期文件。
   - 验证源仓库示例和生成后的模板都能编译。

5. **准备 PR 分支**
   - 运行 `script/typst-package-pr.sh --force-workdir --change-summary "<变更摘要>" --ai-tool-model "<AI 工具和具体模型>"`。
   - 脚本会提交并推送 `v<version>` 到配置的 fork，然后打印 PR 标题和正文。
   - 继续前必须检查打印出来的 PR 正文是否准确。

6. **人工确认闸门**
   - 必须把完整 PR 标题和正文展示给维护者。
   - 维护者明确确认 PR 文案前，不要运行 `gh pr create`。
   - 确认后运行 `script/typst-package-pr.sh --create-pr-only --pr-reviewed --workdir <workdir>`，复用已经推送的发布提交。

7. **PR 创建后**
   - 用 `gh pr view` 确认 PR 元数据。
   - 用 `gh pr checks` 查看 CI。
   - 向维护者报告 PR URL 以及 pending 或 failing 的检查项。

## PR 正文要求

包更新 PR 使用官方模板的结构：

```markdown
I am submitting
- [ ] a new package
- [x] an update for a package

Description: Patch release for `<package-name>`.

<简短、具体的变更说明>

Validation:
- `<源仓库编译命令>`
- `<缩略图编译命令>`
- `<生成包模板编译命令>`

AI assistance disclosure:
This package update and PR preparation were assisted by <AI tool and exact model>. The package contents, generated release files, validation steps, and PR description were reviewed by the human package author before submission.
```

AI 声明必须写明本次会话实际使用的工具和具体模型。如果无法从会话中确认具体模型，创建 PR 前必须询问维护者。

## 安全规则

- 源仓库有未提交变更时不要发布，除非维护者明确说明这些文件就是本次发布变更。
- `script/typst-package-pr.sh --allow-dirty` 只能用于修改发布工具时的本地验证。
- 不要复用已有发布工作目录，除非明确使用 `--force-workdir`。
- 不要覆盖 `typst/packages` 中已经发布的版本目录；包版本视为不可变。
- 不要创建泛泛而谈或明显膨胀的 AI 风格 PR 描述。保持简短、具体、可核验。
