# 开发指南

## 版本更新流程

本文档描述了更新 Cask 或 Formula 文件的标准流程。

### 1. Fork 仓库

1. 访问 [samzong/homebrew-tap](https://github.com/samzong/homebrew-tap)
2. 点击右上角的 "Fork" 按钮创建分支

### 2. 克隆仓库

```bash
git clone https://github.com/samzong/homebrew-tap.git
cd homebrew-tap
```

### 3. 创建更新分支

```bash
git checkout -b update-APP_NAME-VERSION
# 示例：git checkout -b update-hf-model-downloader-0.0.4
```

### 4. 更新文件内容

#### Cask 应用（GUI 应用）

更新 `Casks/APP_NAME.rb` 文件中的以下字段：
```ruby
version "NEW_VERSION"
sha256 "NEW_SHA256"
url "NEW_DOWNLOAD_URL"
```

计算 SHA256 值：
```bash
# 本地文件计算
shasum -a 256 APP_NAME.dmg

# 远程文件计算
curl -sL "DOWNLOAD_URL" | shasum -a 256
```

#### Formula（命令行工具）

更新 `Formula/APP_NAME.rb` 文件中的以下字段：
```ruby
version "NEW_VERSION"
sha256 "NEW_SHA256"
url "NEW_DOWNLOAD_URL"
```

### 5. 提交更改

```bash
git add .
git commit -m "chore: update APP_NAME to vNEW_VERSION"
git push origin update-APP_NAME-VERSION
```

### 6. 创建 Pull Request

1. 访问 Fork 的仓库
2. 点击 "Compare & pull request" 按钮
3. 按以下格式填写 PR：

标题格式：
```
chore: update APP_NAME to vNEW_VERSION
```

描述模板：
```markdown
更新说明：
- 版本：vNEW_VERSION
- 下载链接：NEW_DOWNLOAD_URL
- SHA256：NEW_SHA256

变更内容：
- [ ] 版本号更新
- [ ] 下载链接更新
- [ ] SHA256 更新
```

## 自动化工具

### 本地自动化脚本

用于快速生成更新 PR 的自动化脚本：

```bash
#!/bin/bash

# 使用方法：./update-app.sh app-name 1.0.0 https://example.com/download/app-1.0.0.dmg
APP_NAME=$1
VERSION=$2
DOWNLOAD_URL=$3

# 参数校验
if [ -z "$APP_NAME" ] || [ -z "$VERSION" ] || [ -z "$DOWNLOAD_URL" ]; then
    echo "Usage: ./update-app.sh app-name version download-url"
    exit 1
fi

# 计算 SHA256
SHA256=$(curl -sL "$DOWNLOAD_URL" | shasum -a 256 | cut -d ' ' -f 1)

# 创建更新分支
git checkout -b update-$APP_NAME-$VERSION

# 定位目标文件
if [ -f "Casks/$APP_NAME.rb" ]; then
    FILE="Casks/$APP_NAME.rb"
elif [ -f "Formula/$APP_NAME.rb" ]; then
    FILE="Formula/$APP_NAME.rb"
else
    echo "Error: Cannot find $APP_NAME.rb"
    exit 1
fi

# 更新文件内容
sed -i '' "s/version \".*\"/version \"$VERSION\"/" "$FILE"
sed -i '' "s|url \".*\"|url \"$DOWNLOAD_URL\"|" "$FILE"
sed -i '' "s/sha256 \".*\"/sha256 \"$SHA256\"/" "$FILE"

# 提交变更
git add "$FILE"
git commit -m "chore: update $APP_NAME to v$VERSION"
git push origin update-$APP_NAME-$VERSION

echo "Done! PR URL: https://github.com/samzong/homebrew-tap/compare/main...$(git config user.name):update-$APP_NAME-$VERSION"
```

使用方法：
```bash
chmod +x update-app.sh
./update-app.sh hf-model-downloader 0.0.4 https://github.com/samzong/hf-downloader/releases/download/v0.0.4/app.dmg
```

### GitHub Action 自动更新

通过 GitHub Action 实现发布时自动更新 Homebrew Tap。

#### 1. Token 配置

1. 创建具有 `repo` 权限的 Personal Access Token (PAT)
2. 在源代码仓库的 Settings -> Secrets 中添加 token，名称为 `HOMEBREW_TAP_TOKEN`

#### 2. 工作流配置

在源代码仓库创建 `.github/workflows/update-homebrew.yml`：

```yaml
name: Update Homebrew Tap

# 触发条件：发布新版本
on:
  release:
    types: [published]

jobs:
  update-tap:
    runs-on: ubuntu-latest
    steps:
      # 检出 homebrew-tap 仓库
      - uses: actions/checkout@v4
        with:
          repository: samzong/homebrew-tap
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          fetch-depth: 0  # 完整历史用于分支创建

      # Git 配置
      - name: Setup Git
        run: |
          git config user.name "GitHub Action"
          git config user.email "action@github.com"

      # 获取发布信息
      - name: Get release info
        id: release
        run: |
          # 提取版本号（移除 v 前缀）
          VERSION="${{ github.event.release.tag_name }}"
          VERSION="${VERSION#v}"
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          
          # 获取下载链接（示例：.dmg 文件）
          DOWNLOAD_URL=$(echo '${{ toJson(github.event.release.assets) }}' | jq -r '.[] | select(.name | endswith(".dmg")) | .browser_download_url')
          echo "download_url=$DOWNLOAD_URL" >> $GITHUB_OUTPUT
          
          # 计算 SHA256
          curl -sL "$DOWNLOAD_URL" | shasum -a 256 | cut -d ' ' -f 1 > sha256.txt
          echo "sha256=$(cat sha256.txt)" >> $GITHUB_OUTPUT

      # 创建更新分支
      - name: Create branch
        run: |
          APP_NAME="${{ github.event.repository.name }}"
          git checkout -b update-$APP_NAME-${{ steps.release.outputs.version }}

      # 更新文件
      - name: Update file
        run: |
          APP_NAME="${{ github.event.repository.name }}"
          
          # 定位目标文件
          if [ -f "Casks/$APP_NAME.rb" ]; then
              FILE="Casks/$APP_NAME.rb"
          elif [ -f "Formula/$APP_NAME.rb" ]; then
              FILE="Formula/$APP_NAME.rb"
          else
              echo "Error: Cannot find $APP_NAME.rb"
              exit 1
          fi
          
          # 更新内容
          sed -i "s/version \".*\"/version \"${{ steps.release.outputs.version }}\"/" "$FILE"
          sed -i "s|url \".*\"|url \"${{ steps.release.outputs.download_url }}\"|" "$FILE"
          sed -i "s/sha256 \".*\"/sha256 \"${{ steps.release.outputs.sha256 }}\"/" "$FILE"

      # 创建 Pull Request
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          commit-message: "chore: update ${{ github.event.repository.name }} to v${{ steps.release.outputs.version }}"
          title: "chore: update ${{ github.event.repository.name }} to v${{ steps.release.outputs.version }}"
          body: |
            更新说明：
            - 版本：v${{ steps.release.outputs.version }}
            - 下载链接：${{ steps.release.outputs.download_url }}
            - SHA256：${{ steps.release.outputs.sha256 }}
            
            变更内容：
            - [x] 版本号更新
            - [x] 下载链接更新
            - [x] SHA256 更新
            
            由 GitHub Action 自动创建
          branch: update-${{ github.event.repository.name }}-${{ steps.release.outputs.version }}
          base: main
          delete-branch: true

#### 3. 配置说明

1. 工作流文件位置：`.github/workflows/update-homebrew.yml`
2. 触发条件：发布新版本时自动执行
3. 自动化流程：
   - 获取版本信息
   - 计算文件 SHA256
   - 创建更新分支
   - 提交 PR

#### 注意事项

- PAT Token 需要具备足够的仓库权限
- 根据实际发布格式（dmg/zip 等）调整下载 URL 获取逻辑
- PR 模板可按需调整 