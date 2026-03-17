git clone --depth 1 --no-checkout --filter="tree:0" git@github.com:golixp/typst-official-packages-repo.git
cd typst-official-packages-repo

# 初始化稀疏检出
git sparse-checkout init
git sparse-checkout set packages/preview/golixp-resume-zh-cn

# 配置上游
git remote add upstream git@github.com:typst/packages
git config remote.upstream.partialclonefilter tree:0

### 更新

# 将当前分支指向上游
git fetch upstream main --depth=1
git checkout -b v0.1.1 upstream/main

# 发布文件
bash ~/project/typst-resume-zh-cn/script/publish.sh ~/project/typst-official-packages-repo/packages/preview/golixp-resume-zh-cn/0.1.1

# 提交
git add . --ignore-removal
git commit -m "golixp-resume-zh-cn:0.1.1"

# 推送
git push origin v0.1.1
