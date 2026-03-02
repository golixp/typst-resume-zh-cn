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

### Clone the Repository

```bash
git clone https://github.com/golixp/typst-resume-zh-cn.git
```

### Integrate via Git Subtree

#### Initial Setup

```bash
git subtree add --prefix=resume-zh-cn https://github.com/golixp/typst-resume-zh-cn.git master --squash
```

#### Pull Updates

```bash
git subtree pull --prefix=resume-zh-cn https://github.com/golixp/typst-resume-zh-cn.git master --squash
```

### Prerequisites

- [Typst](https://typst.app/) >= 0.11.0
- Fonts: Noto Sans, Noto Sans CJK SC, Symbols Nerd Font

### Compile

```bash
typst compile example.typ
```

## GitHub Actions Auto-Release

The project includes a GitHub Actions workflow (`.github/workflows/release.yml`) that automatically compiles Typst documents and publishes the generated PDF to GitHub Releases when a Git tag is pushed.

### Configuration

Edit `.github/workflows/release.yml` and set the `TYPST_SOURCE` environment variable to the target Typst source filename (without the `.typ` extension):

```yaml
env:
  TYPST_SOURCE: example  # Replace with your filename
```

If your resume source file is located in a subdirectory, set `TYPST_SOURCE` to the path relative to the repository root (without the `.typ` extension):

```yaml
env:
  TYPST_SOURCE: docs/resume  # Corresponds to docs/resume.typ
```

### Configuring in an Existing Repository

If you integrate this template into an existing repository via file copying or Git Subtree, you need to manually configure the workflow. GitHub Actions only recognizes workflow files in `.github/workflows/` at the repository root, so you must copy the workflow file to the correct location.

#### Direct File Copy Integration

Copy the `.github/workflows/release.yml` from this project to your repository:

```bash
mkdir -p .github/workflows
cp <repository-directory>/.github/workflows/release.yml .github/workflows/release.yml
```

#### Git Subtree Integration

When files are introduced via Git Subtree under a specific prefix directory (e.g., `resume-zh-cn/`), the `.github/` directory within it will not be recognized by GitHub Actions. You need to manually copy the workflow file to the repository root:

```bash
mkdir -p .github/workflows
cp resume-zh-cn/.github/workflows/release.yml .github/workflows/release.yml
```

Then adjust `TYPST_SOURCE` according to the actual location of your resume source file.

> **Tip**: Regardless of the integration method used, the value of `TYPST_SOURCE` should always be the path to the resume source file relative to the repository root, without the `.typ` extension.

### Trigger a Release

Create a Git tag and push it to the remote repository to trigger the automated build:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow will automatically: install required fonts, compile the Typst document to PDF, create a GitHub Release and upload the PDF file.

> **Note**: The workflow is triggered only by tag pushes. Regular commits will not trigger the release process.

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
