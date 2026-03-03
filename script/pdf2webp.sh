#!/bin/bash

set -euo pipefail

# 设置变量
INPUT_PDF="example.typ"
PREFIX="screenshot"
QUALITY=75
METHOD=6

# 检查输入文件是否存在
if [ ! -f "$INPUT_PDF" ]; then
    echo "错误: 找不到文件 $INPUT_PDF"
    exit 1
fi

# 检查依赖工具
if ! command -v typst &> /dev/null || ! command -v cwebp &> /dev/null; then
    echo "错误: 请确保已安装 typst 和 libwebp-tools (cwebp)"
    exit 1
fi

echo "正在从 $INPUT_PDF 提取页面 (300 DPI)..."
# pdftoppm 渲染 PDF 为 ppm 图片
typst compile -f png --pages 1- --ppi 300 "$INPUT_PDF" "$PREFIX-{p}.png"

# 循环转换所有生成的 ppm 文件
echo "正在转换为 WebP (质量: $QUALITY, 压缩级别: $METHOD)..."
for f in "$PREFIX"*.png; do
    # 检查文件是否存在（防止通配符未匹配到文件的情况）
    [ -e "$f" ] || continue
    
    # 构造输出文件名 (将 .ppm 替换为 .webp)
    OUTPUT_FILE="${f%.png}.webp"
    
    echo "正在转换: $f -> $OUTPUT_FILE"
    cwebp -q $QUALITY -m $METHOD "$f" -o "$OUTPUT_FILE"
done

echo "转换完成！"