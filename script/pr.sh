git clone --depth 1 --no-checkout --filter="tree:0" git@github.com:golixp/typst-official-packages-repo.git
cd typst-official-packages-repo

# 初始化稀疏检出
git sparse-checkout init
git sparse-checkout set packages/preview/golixp-resume-zh-cn

# 配置上游
git remote add upstream git@github.com:typst/packages
git config remote.upstream.partialclonefilter tree:0

# 发布文件
bash ~/project/typst-resume-zh-cn/script/publish.sh ~/project/typst-official-packages-repo/packages/preview/golixp-resume-zh-cn/0.1.0

# 提交
git add . --ignore-removal
git commit -m "resume-zh-cn:0.1.0"

# 拉取上游
git fetch upstream
git rebase upstream/main

# 推送
git push origin main --force
