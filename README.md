# Typst 简历模板 (简体中文)

[English](README_en.md) | 中文

一个使用 [Typst](https://typst.app/) 编写的模块化简历模板，专为简体中文排版优化。

## 特性

- **模块化设计** - 配置、组件、图标、章节分离，便于维护和定制
- **中文优化** - 针对简体中文排版调优，字体栈包含 Noto Sans CJK SC
- **丰富组件** - 提供工作经历、教育背景、项目经历、技能展示等常用简历组件
- **图标支持** - 集成 Nerdfont 图标，支持 60+ 常用图标
- **高度可配置** - 字体、颜色、间距、布局均可通过配置文件调整
- **多种布局** - 支持双列、三列、侧边栏、时间轴等布局方式

## 快速开始

### 克隆仓库

```bash
git clone https://github.com/golixp/typst-resume-zh-cn.git
```

### 通过 Git Subtree 集成到已有仓库

#### 首次引入

```bash
git subtree add --prefix=modules https://github.com/golixp/typst-resume-zh-cn.git master --squash
```

#### 拉取更新

```bash
git subtree pull --prefix=modules https://github.com/golixp/typst-resume-zh-cn.git master --squash
```

### 前置要求

- [Typst](https://typst.app/) >= 0.11.0
- 字体：Noto Sans、Noto Sans CJK SC、Symbols Nerd Font

### 编译

```bash
typst compile example.typ
```

## 项目结构

```
.
├── example.typ          # 示例简历文件
├── modules/
│   ├── config.typ       # 配置模块（字体、颜色、间距等）
│   ├── icons.typ        # 图标模块（Nerdfont 图标定义）
│   ├── components.typ   # 基础组件（布局、列表、卡片等）
│   └── sections.typ     # 章节组件（工作经历、教育等）
└── README.md
```

## 使用方法

### 导入模块

```typst
#import "modules/config.typ": *
#import "modules/icons.typ": icon, icon-label
#import "modules/components.typ": *
#import "modules/sections.typ": *
```

### 个人信息

```typst
#personal-header(
  "姓名",
  (
    (icon: "phone", content: "138-0000-0000"),
    (icon: "email", content: "email@example.com"),
    (icon: "github", content: "github.com/user", link: "https://github.com/user"),
  ),
)
```

### 工作经历

```typst
#section-header("工作经历", icon-name: "work")

#work-item(
  "2021.06 - 至今",
  "公司名称",
  "职位",
  location: "北京",
  tech-stack: ("Go", "Python", "Kubernetes"),
  responsibilities: (
    [工作职责 1],
    [工作职责 2],
  ),
  achievements: (
    [主要成就],
  ),
)
```

### 教育经历

```typst
#section-header("教育经历", icon-name: "graduation")

#education-item(
  "2015.09 - 2019.06",
  "大学名称",
  "本科",
  "专业名称",
  gpa: "3.8/4.0",
  honors: ("荣誉 1", "荣誉 2"),
)
```

### 项目经历

```typst
#section-header("项目经历", icon-name: "project")

#project-item(
  "项目名称",
  ("Go", "gRPC", "etcd"),
  [项目描述],
  responsibilities: (
    [职责 1],
    [职责 2],
  ),
  link: "https://github.com/example/project",
)
```

### 技能展示

```typst
#section-header("专业技能", icon-name: "code")

#skill-category(
  "编程语言",
  ("Go", "Python", "Java", "TypeScript"),
  level: "精通",
)
```

## 配置选项

编辑 `modules/config.typ` 自定义样式：

| 配置项 | 说明 |
|--------|------|
| `fonts` | 字体族定义 |
| `colors` | 颜色配置（主题色、文本色等） |
| `font-sizes` | 字号配置 |
| `spacing` | 间距配置 |
| `page-margins` | 页面边距 |
| `style-features` | 样式开关（链接下划线、段落对齐等） |
| `layout-defaults` | 布局参数（侧边栏宽度、列比例等） |

### 自定义主题色

```typst
// 在 config.typ 中修改
#let theme-color = rgb(38, 38, 125)  // 修改为你喜欢的颜色
```

## 可用组件

### 基础组件 (components.typ)

| 组件 | 说明 |
|------|------|
| `list-view` | 通用列表 |
| `description-list` | 描述列表（键值对） |
| `tag-list` | 标签列表 |
| `two-col` / `three-col` | 多列布局 |
| `sidebar` | 侧边栏布局 |
| `card` / `bordered-card` / `info-card` | 卡片组件 |
| `timeline` / `timeline-item` | 时间轴 |
| `styled-link` / `icon-link` | 链接组件 |
| `date-text` / `label-text` / `tech-text` | 文本样式 |

### 章节组件 (sections.typ)

| 组件 | 说明 |
|------|------|
| `section-header` | 章节标题 |
| `personal-header` | 个人信息头部 |
| `work-item` / `work-list` | 工作经历 |
| `education-item` / `education-list` | 教育经历 |
| `project-item` / `project-list` | 项目经历 |
| `skill-category` / `skill-list` / `skill-cloud` | 技能展示 |
| `award-item` / `award-list` | 获奖荣誉 |
| `summary-paragraph` / `summary-list` | 个人总结 |

### 图标 (icons.typ)

| 组件 | 说明 |
|------|------|
| `icon` | 显示单个图标 |
| `icon-label` | 图标 + 文本标签 |
| `tech-icon` | 技术栈图标 |

支持的图标：`phone`、`email`、`location`、`github`、`linkedin`、`work`、`graduation`、`project`、`code`、`award` 等 60+ 种。

## 许可证

[MIT License](LICENSE)

---

> 部分代码和文档由 AI 辅助生成
