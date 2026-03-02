// ============================================
// 基础组件模块 (Base Components Module)
// ============================================
// 本模块提供通用的基础布局组件，包括列表、布局、卡片等
// 所有组件都支持高度自定义配置

#import "config.typ": *
#import "icons.typ": icon

// --------------------------------------------
// 列表组件 (List Components)
// --------------------------------------------

/// 通用列表组件
/// 支持自定义标记符号和样式
///
/// 参数:
///   items: 列表项内容数组
///   marker: 列表标记符号，默认为配置中的 list-marker
///   spacing: 列表项间距
///   indent: 缩进量
#let list-view(
  items,
  marker: style-features.list-marker,
  spacing: spacing.list-item,
  indent: 0em,
) = {
  set list(marker: marker, spacing: spacing)
  pad(left: indent, list(..items))
}

/// 描述列表（键值对列表）
/// 以标签+描述的形式展示
///
/// 参数:
///   items: 字典或数组形式的键值对
///   label-width: 标签宽度
///   gap: 标签与内容间距
///   label-style: 标签样式函数
#let description-list(
  items,
  label-width: 20%,
  gap: 0.5em,
  label-style: (it) => strong(it),
) = {
  let entries = if type(items) == dictionary {
    items.pairs()
  } else {
    items
  }
  
  for (key, value) in entries {
    grid(
      columns: (label-width, 1fr),
      column-gutter: gap,
      align(left + top, label-style(key)),
      align(left + top, value),
    )
    v(spacing.list-item)
  }
}

/// 标签列表
/// 以标签形式展示多个项目
///
/// 参数:
///   items: 标签内容数组
///   color: 标签颜色
///   bg-color: 背景色
///   radius: 圆角
///   padding: 内边距
///   gap: 标签间距
#let tag-list(
  items,
  color: colors.primary,
  bg-color: colors.background,
  radius: layout-defaults.card-radius,
  padding: (x: 0.4em, y: 0.15em),
  gap: 0.3em,
) = {
  h(0.1em)
  for item in items {
    box(
      fill: bg-color,
      radius: radius,
      inset: padding,
      text(size: font-sizes.small, fill: color, item)
    )
    h(gap)
  }
}

// --------------------------------------------
// 布局组件 (Layout Components)
// --------------------------------------------

/// 双列布局组件
/// 支持灵活的宽度分配
///
/// 参数:
///   left: 左侧内容
///   right: 右侧内容
///   ratio: 列宽比例，默认为 (1fr, 1fr)
///   gutter: 列间距
///   align-left: 左侧对齐方式
///   align-right: 右侧对齐方式
#let two-col(
  left,
  right,
  ratio: layout-defaults.two-col-ratio,
  gutter: 1em,
  align-left: left,
  align-right: left,
) = {
  grid(
    columns: ratio,
    column-gutter: gutter,
    align(align-left, left),
    align(align-right, right),
  )
}

/// 三列布局组件
/// 支持响应式或固定比例
///
/// 参数:
///   left: 左侧内容
///   center: 中间内容
///   right: 右侧内容
///   ratio: 列宽比例
///   gutter: 列间距
#let three-col(
  left,
  center,
  right,
  ratio: layout-defaults.three-col-ratio,
  gutter: 1em,
) = {
  grid(
    columns: ratio,
    column-gutter: gutter,
    left, center, right,
  )
}

/// 侧边栏组件（带分割线）
/// 左侧为侧边栏，右侧为主内容区
///
/// 参数:
///   side: 侧边栏内容
///   content: 主内容
///   with-line: 是否显示分割线
///   side-width: 侧边栏宽度
///   line-color: 分割线颜色
///   line-stroke: 分割线粗细
///   gap: 内容间距
#let sidebar(
  side,
  content,
  with-line: true,
  side-width: layout-defaults.sidebar-width,
  line-color: colors.primary,
  line-stroke: layout-defaults.timeline-stroke,
  gap: 0.75em,
) = context {
  let side-size = measure(side)
  let content-size = measure(content)
  let height = calc.max(side-size.height, content-size.height) + 0.5em
  
  grid(
    columns: (side-width, if with-line { 0% } else { 0pt }, 1fr),
    column-gutter: gap,
    {
      set align(right + top)
      v(0.25em)
      side
      v(0.25em)
    },
    if with-line {
      line(end: (0em, height), stroke: line-stroke + line-color)
    },
    {
      v(0.25em)
      content
      v(0.25em)
    },
  )
}

/// 水平分隔线
/// 带颜色的分隔线
///
/// 参数:
///   color: 线条颜色
///   stroke: 线条粗细
///   length: 线条长度
#let divider(
  color: colors.border,
  stroke: 0.05em,
  length: 100%,
) = {
  line(length: length, stroke: stroke + color)
}

/// 垂直间距
/// 创建指定高度的垂直空白
///
/// 参数:
///   amount: 间距大小
#let v-space(amount) = v(amount)

/// 水平间距
/// 创建指定宽度的水平空白
///
/// 参数:
///   amount: 间距大小
#let h-space(amount) = h(amount)

// --------------------------------------------
// 卡片组件 (Card Components)
// --------------------------------------------

/// 基础卡片组件
/// 带背景色和圆角的容器
///
/// 参数:
///   content: 卡片内容
///   fill: 背景填充色
///   stroke: 边框样式
///   radius: 圆角半径
///   padding: 内边距
///   width: 宽度
#let card(
  content,
  fill: colors.background,
  stroke: none,
  radius: layout-defaults.card-radius,
  padding: layout-defaults.card-padding,
  width: 100%,
) = {
  box(
    width: width,
    fill: fill,
    stroke: stroke,
    radius: radius,
    inset: padding,
    content,
  )
}

/// 边框卡片
/// 带边框的卡片
///
/// 参数:
///   content: 卡片内容
///   border-color: 边框颜色
///   border-width: 边框宽度
///   ...其他参数同 card
#let bordered-card(
  content,
  border-color: colors.border,
  border-width: 0.05em,
  fill: none,
  ..args,
) = {
  card(
    content,
    fill: fill,
    stroke: border-width + border-color,
    ..args,
  )
}

/// 信息卡片
/// 带图标和标题的信息展示卡片
///
/// 参数:
///   title: 卡片标题
///   content: 卡片内容
///   icon-name: 图标名称（可选）
///   icon-color: 图标颜色
#let info-card(
  title,
  content,
  icon-name: none,
  icon-color: colors.primary,
  ..args,
) = {
  card({
    if icon-name != none {
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.5em,
        align(top, icon(icon-name, color: icon-color)),
        {
          strong(title)
          v(0.3em)
          content
        },
      )
    } else {
      strong(title)
      v(0.3em)
      content
    }
  }, ..args)
}

// --------------------------------------------
// 时间轴组件 (Timeline Components)
// --------------------------------------------

/// 时间轴项
/// 单个时间轴条目
///
/// 参数:
///   period: 时间段
///   title: 标题
///   subtitle: 副标题（可选）
///   description: 描述内容（可选）
///   tags: 标签数组（可选）
///   line-color: 时间线颜色
///   dot-color: 圆点颜色
#let timeline-item(
  period,
  title,
  subtitle: none,
  description: none,
  tags: (),
  line-color: colors.primary,
  dot-color: colors.primary,
) = {
  grid(
    columns: (18%, 1fr),
    column-gutter: 1em,
    {
      // 左侧时间
      set align(right + top)
      text(size: font-sizes.small, fill: colors.secondary, period)
    },
    {
      // 右侧内容
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.5em,
        {
          // 时间轴圆点
          box(
            width: 0.5em,
            height: 0.5em,
            radius: 50%,
            fill: dot-color,
          )
        },
        {
          // 内容区
          strong(title)
          if subtitle != none {
            h(0.5em)
            text(size: font-sizes.small, fill: colors.secondary, subtitle)
          }
          if description != none {
            v(0.3em)
            description
          }
          if tags.len() > 0 {
            v(0.3em)
            tag-list(tags, color: colors.primary)
          }
        },
      )
    },
  )
  v(spacing.list-item)
}

/// 时间轴容器
/// 包含多个时间轴项的容器
///
/// 参数:
///   items: 时间轴项数组，每项为字典
#let timeline(
  items,
) = {
  for item in items {
    timeline-item(
      period: item.at("period", default: ""),
      title: item.at("title", default: ""),
      subtitle: item.at("subtitle", default: none),
      description: item.at("description", default: none),
      tags: item.at("tags", default: ()),
    )
  }
}

// --------------------------------------------
// 文本样式组件 (Text Style Components)
// --------------------------------------------

/// 日期文本
/// 灰色小字样式，用于日期展示
///
/// 参数:
///   content: 日期内容
///   color: 文本颜色，默认为次要色
///   size: 字号，默认为 small
#let date-text(
  content,
  color: colors.secondary,
  size: font-sizes.small,
) = {
  text(fill: color, size: size, content)
}

/// 标签文本
/// 用于技能标签、分类标签等
///
/// 参数:
///   content: 标签内容
///   color: 文本颜色
///   weight: 字重
#let label-text(
  content,
  color: colors.primary,
  weight: "regular",
) = {
  text(fill: color, weight: weight, content)
}

/// 技术栈文本
/// 细体字样式，用于技术栈展示
///
/// 参数:
///   content: 技术栈内容
#let tech-text(content) = {
  text(weight: "extralight", content)
}

/// 强调文本
/// 高亮显示的重要文本
///
/// 参数:
///   content: 文本内容
///   color: 强调色
#let highlight-text(
  content,
  color: colors.primary,
) = {
  text(fill: color, weight: "bold", content)
}

// --------------------------------------------
// 链接组件 (Link Components)
// --------------------------------------------

/// 样式化链接
/// 带颜色的链接文本
///
/// 参数:
///   url: 链接地址
///   text: 显示文本（可选，默认为URL）
///   color: 链接颜色
#let styled-link(
  url,
  text-content: none,
  color: colors.primary,
) = {
  let display-text = if text-content == none { url } else { text-content }
  link(url, text(fill: color, display-text))
}

/// 带图标的链接
/// 链接前显示图标
///
/// 参数:
///   url: 链接地址
///   icon-name: 图标名称
///   text: 显示文本
///   color: 颜色
#let icon-link(
  url,
  icon-name,
  text-content,
  color: colors.primary,
) = {
  box({
    icon(icon-name, color: color)
    h(0.3em)
    link(url, text(fill: color, text-content))
  })
}

// --------------------------------------------
// 导出 (Exports)
// --------------------------------------------

// 直接导出所有组件函数
#let list = list-view
#let description-list = description-list
#let tag-list = tag-list
#let two-col = two-col
#let three-col = three-col
#let sidebar = sidebar
#let divider = divider
#let v-space = v-space
#let h-space = h-space
#let card = card
#let bordered-card = bordered-card
#let info-card = info-card
#let timeline = timeline
#let timeline-item = timeline-item
#let date = date-text
#let label = label-text
#let tech = tech-text
#let highlight = highlight-text
#let link = styled-link
#let icon-link = icon-link

/// 导出所有组件字典（用于需要传递所有组件的场景）
#let components = (
  list: list-view,
  description-list: description-list,
  tag-list: tag-list,
  two-col: two-col,
  three-col: three-col,
  sidebar: sidebar,
  divider: divider,
  v-space: v-space,
  h-space: h-space,
  card: card,
  bordered-card: bordered-card,
  info-card: info-card,
  timeline: timeline,
  timeline-item: timeline-item,
  date: date-text,
  label: label-text,
  tech: tech-text,
  highlight: highlight-text,
  link: styled-link,
  icon-link: icon-link,
)
