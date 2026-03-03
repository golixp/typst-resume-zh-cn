#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "用法: $0 <目标目录>"
  exit 1
fi

TARGET_DIR="$1"

# 创建目标目录
mkdir -p "$TARGET_DIR"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

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
  tmp_zh="$(mktemp)"
  tmp_en="$(mktemp)"

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
  ' "$ZH_SRC" > "$tmp_zh"

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
  ' "$EN_SRC" > "$tmp_en"

  # 中文在前，英文在后
  cat "$tmp_zh" "$tmp_en" > "$MERGED_README"

  rm -f "$tmp_zh" "$tmp_en"
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

