// ============================================
// 配置模块 (Configuration Module)
// ============================================
// 本模块集中管理简历模板的所有配置项，包括字体、颜色、尺寸等基础参数

// --------------------------------------------
// 字体配置 (Font Configuration)
// --------------------------------------------

/// 字体族定义
/// 包含主字体、等宽字体、中文无衬线字体、Nerdfont图标字体和Emoji字体
#let fonts = (
  // 主字体 - 用于正文和标题
  main: "Noto Sans",
  
  // 等宽字体 - 用于代码和技术术语
  mono: "Noto Sans Mono",
  
  // 中文无衬线字体
  sc: "Noto Sans CJK SC",
  
  // Nerdfont 图标字体 - 用于显示各类图标
  // 需要系统中安装 nerd-fonts 字体包
  nerd: "Symbols Nerd Font",

  nerd-mono: "Symbols Nerd Font Mono",
  
  // Emoji 字体 - 用于显示表情符号
  emoji: "Noto Color Emoji",
)

/// 获取完整字体栈（按优先级排序）
/// 返回包含主字体、中文和Emoji字体的数组
#let font-stack = (fonts.main, fonts.sc, fonts.emoji, fonts.nerd)

/// 获取代码字体栈
/// 返回包含等宽字体和Emoji字体的数组
#let mono-font-stack = (fonts.mono, fonts.emoji, fonts.nerd-mono)

// --------------------------------------------
// 颜色配置 (Color Configuration)
// --------------------------------------------

/// 主题颜色定义
/// 用于标题、链接、图标等强调元素
#let theme-color = rgb(38, 38, 125)

/// 辅助颜色定义
#let colors = (
  // 主题色
  primary: theme-color,
  
  // 次要文本颜色 - 用于日期、说明文字
  secondary: rgb(128, 128, 128),
  
  // 浅色文本 - 用于标签、提示
  light: rgb(160, 160, 160),
  
  // 背景色 - 用于卡片背景
  background: rgb(245, 245, 250),
  
  // 边框色
  border: rgb(200, 200, 220),
  
  // 纯黑和纯白
  black: rgb(0, 0, 0),
  white: rgb(255, 255, 255),
)

// --------------------------------------------
// 尺寸配置 (Size Configuration)
// --------------------------------------------

/// 基础字号配置
#let font-sizes = (
  // 基准字号
  base: 10pt,
  
  // 一级标题（姓名）
  h1: 1.4em,
  
  // 二级标题（章节标题）
  h2: 1.2em,
  
  // 三级标题（小节标题）
  h3: 1.1em,
  
  // 小字（日期、标签）
  small: 0.9em,
  
  // 超小字（脚注）
  xsmall: 0.8em,
)

/// 间距配置
#let spacing = (
  // 段落间距
  paragraph: 0.65em,
  
  // 章节间距
  section: 0.8em,
  
  // 小节间距
  subsection: 0.5em,
  
  // 列表项间距
  list-item: 0.4em,
  
  // 组件内部间距
  component-inner: 0.5em,
  
  // 组件外部间距
  component-outer: 0.75em,
)

/// 页面边距配置
#let page-margins = (
  top: 1cm,
  bottom: 1cm,
  left: 1.5cm,
  right: 1.5cm,
)

// --------------------------------------------
// 样式开关配置 (Style Toggle Configuration)
// --------------------------------------------

/// 样式特性开关
#let style-features = (
  // 是否启用链接下划线
  link-underline: false,
  
  // 是否启用标题自动编号
  heading-numbering: false,
  
  // 是否启用段落两端对齐
  paragraph-justify: true,
  
  // 列表标记符号
  list-marker: [-],
  
  // 标题分隔线粗细
  heading-line-stroke: 0.05em,
)

// --------------------------------------------
// 布局配置 (Layout Configuration)
// --------------------------------------------

/// 默认布局参数
#let layout-defaults = (
  // 侧边栏默认宽度（百分比）
  sidebar-width: 16%,
  
  // 双列布局默认比例
  two-col-ratio: (1fr, 1fr),
  
  // 三列布局默认比例
  three-col-ratio: (1fr, 1fr, 1fr),
  
  // 时间轴线条粗细
  timeline-stroke: 0.05em,
  
  // 卡片圆角
  card-radius: 0.3em,
  
  // 卡片内边距
  card-padding: 0.5em,
)

// --------------------------------------------
// 导出配置 (Export Configuration)
// --------------------------------------------

// 直接导出所有配置变量
#let fonts = fonts
#let font-stack = font-stack
#let mono-font-stack = mono-font-stack
#let colors = colors
#let theme-color = theme-color
#let font-sizes = font-sizes
#let spacing = spacing
#let page-margins = page-margins
#let style-features = style-features
#let layout-defaults = layout-defaults

/// 导出完整的配置字典，便于一次性导入
#let config = (
  fonts: fonts,
  font-stack: font-stack,
  mono-font-stack: mono-font-stack,
  colors: colors,
  theme-color: theme-color,
  font-sizes: font-sizes,
  spacing: spacing,
  page-margins: page-margins,
  style-features: style-features,
  layout-defaults: layout-defaults,
)
