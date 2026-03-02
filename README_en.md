# Typst Resume Template (Simplified Chinese)

English | [中文](README.md)

> **Warning**: This template is optimized for **Simplified Chinese** typography. English-only layouts have **not been tested** and may require adjustments.

A modular resume template built with [Typst](https://typst.app/), optimized for Simplified Chinese typography.

## Features

- **Modular Architecture** - Separate config, components, icons, and sections for easy maintenance
- **CJK Optimized** - Fine-tuned for Simplified Chinese with Noto Sans CJK SC font stack
- **Rich Components** - Work experience, education, projects, skills, and more
- **Icon Support** - Integrated Nerdfont icons with 60+ commonly used icons
- **Highly Configurable** - Fonts, colors, spacing, and layouts all customizable
- **Multiple Layouts** - Two-column, three-column, sidebar, timeline layouts

## Quick Start

### Prerequisites

- [Typst](https://typst.app/) >= 0.11.0
- Fonts: Noto Sans, Noto Sans CJK SC, Symbols Nerd Font

### Compile

```bash
typst compile example.typ
```

## Project Structure

```
.
├── example.typ          # Example resume file
├── modules/
│   ├── config.typ       # Configuration (fonts, colors, spacing)
│   ├── icons.typ        # Icon definitions (Nerdfont)
│   ├── components.typ   # Base components (layouts, lists, cards)
│   └── sections.typ     # Section components (work, education, etc.)
└── README.md
```

## Usage

### Import Modules

```typst
#import "modules/config.typ": *
#import "modules/icons.typ": icon, icon-label
#import "modules/components.typ": *
#import "modules/sections.typ": *
```

### Personal Information

```typst
#personal-header(
  "Your Name",
  (
    (icon: "phone", content: "+1-234-567-8900"),
    (icon: "email", content: "email@example.com"),
    (icon: "github", content: "github.com/user", link: "https://github.com/user"),
  ),
)
```

### Work Experience

```typst
#section-header("Work Experience", icon-name: "work")

#work-item(
  "2021.06 - Present",
  "Company Name",
  "Position",
  location: "City",
  tech-stack: ("Go", "Python", "Kubernetes"),
  responsibilities: (
    [Responsibility 1],
    [Responsibility 2],
  ),
  achievements: (
    [Achievement],
  ),
)
```

### Education

```typst
#section-header("Education", icon-name: "graduation")

#education-item(
  "2015.09 - 2019.06",
  "University Name",
  "Bachelor",
  "Major",
  gpa: "3.8/4.0",
  honors: ("Honor 1", "Honor 2"),
)
```

### Projects

```typst
#section-header("Projects", icon-name: "project")

#project-item(
  "Project Name",
  ("Go", "gRPC", "etcd"),
  [Project description],
  responsibilities: (
    [Contribution 1],
    [Contribution 2],
  ),
  link: "https://github.com/example/project",
)
```

### Skills

```typst
#section-header("Skills", icon-name: "code")

#skill-category(
  "Programming Languages",
  ("Go", "Python", "Java", "TypeScript"),
  level: "Expert",
)
```

## Configuration

Edit `modules/config.typ` to customize styles:

| Option | Description |
|--------|-------------|
| `fonts` | Font family definitions |
| `colors` | Color palette (theme, text colors) |
| `font-sizes` | Font size settings |
| `spacing` | Spacing configuration |
| `page-margins` | Page margins |
| `style-features` | Style toggles (link underlines, justification) |
| `layout-defaults` | Layout parameters (sidebar width, column ratios) |

### Custom Theme Color

```typst
// Modify in config.typ
#let theme-color = rgb(38, 38, 125)  // Change to your preferred color
```

## Available Components

### Base Components (components.typ)

| Component | Description |
|-----------|-------------|
| `list-view` | Generic list |
| `description-list` | Key-value list |
| `tag-list` | Tag list |
| `two-col` / `three-col` | Multi-column layouts |
| `sidebar` | Sidebar layout |
| `card` / `bordered-card` / `info-card` | Card components |
| `timeline` / `timeline-item` | Timeline |
| `styled-link` / `icon-link` | Link components |
| `date-text` / `label-text` / `tech-text` | Text styles |

### Section Components (sections.typ)

| Component | Description |
|-----------|-------------|
| `section-header` | Section heading |
| `personal-header` | Personal info header |
| `work-item` / `work-list` | Work experience |
| `education-item` / `education-list` | Education |
| `project-item` / `project-list` | Projects |
| `skill-category` / `skill-list` / `skill-cloud` | Skills |
| `award-item` / `award-list` | Awards |
| `summary-paragraph` / `summary-list` | Summary |

### Icons (icons.typ)

| Component | Description |
|-----------|-------------|
| `icon` | Display single icon |
| `icon-label` | Icon with text label |
| `tech-icon` | Tech stack icon |

Supported icons: `phone`, `email`, `location`, `github`, `linkedin`, `work`, `graduation`, `project`, `code`, `award`, and 60+ more.

## License

[MIT License](LICENSE)

---

> Some code and documentation generated with AI assistance
