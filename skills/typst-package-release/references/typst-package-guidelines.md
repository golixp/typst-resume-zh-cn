# Typst 官方包发布规范参考

本文件最后一次在 `golixp-resume-zh-cn:0.1.2` 发布时核对，日期为 2026-05-16。每次发布都要重新打开这些链接确认规则没有变化。

## 官方来源

- 仓库：https://github.com/typst/packages
- 提交流程：https://github.com/typst/packages/blob/main/docs/README.md
- Manifest 规则：https://github.com/typst/packages/blob/main/docs/manifest.md
- 文档规则：https://github.com/typst/packages/blob/main/docs/documentation.md
- 许可证规则：https://github.com/typst/packages/blob/main/docs/licensing.md
- 提交与排除文件建议：https://github.com/typst/packages/blob/main/docs/tips.md
- 资源处理建议：https://github.com/typst/packages/blob/main/docs/resources.md
- PR 模板：https://github.com/typst/packages/blob/main/.github/pull_request_template.md

## 必须应用的规则

- PR 标题必须是 `<package-name>:<version>`。
- 新版本目录必须放在 `packages/preview/<package-name>/<version>`。
- 发布新版本时不要修改已经发布的旧版本目录。
- 包目录应包含 `typst.toml`、`README.md`、`LICENSE`、入口文件、模板文件和必要源码模块。
- 除非上游规则明确要求，不要提交生成的 PDF 或大型文档图片。
- 对模板包，要确认用户可以在正常使用并修改模板后继续使用和分发模板目录内容。
- 打开 PR 前必须在本地编译验证。
- 模板示例导入的版本必须和本次提交的版本一致。

## 资源处理备注

官方资源文档建议：模板中可由用户替换的图片应作为 content 参数传入，而不是使用文件系统 path string。`0.1.2` 发布的 bug fix 正是把 photo 处理从 path string 改为 image content，因此 PR 描述中引用了这一点。

## AI 辅助提交政策

在 `0.1.2` 发布时，没有在官方文档、PR 模板或仓库代码搜索中发现禁止 AI 辅助提交的规则。相关 issue 中可以看到维护者更偏好清晰的人类沟通，而不是大段 ChatGPT 风格文本：

- https://github.com/typst/packages/issues/1323

推荐使用简短 AI 声明：

```text
This package update and PR preparation were assisted by <AI tool and exact model>. The package contents, generated release files, validation steps, and PR description were reviewed by the human package author before submission.
```

如果当前上游文档新增 AI 相关规则，以新规则为准。

## 本仓库默认值

- 源仓库：`golixp/typst-resume-zh-cn`
- Typst packages fork：`golixp/typst-official-packages-repo`
- 上游仓库：`typst/packages`
- 发布分支：`v<version>`
- 生成工作目录：`/tmp/typst-packages-<package-name>-<version>`
