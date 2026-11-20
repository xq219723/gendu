# 影子跟读助手 · 安装包下载

本仓库只用于分发安装包，不存放源码。版本号与客户端一致（如 `1.0.1+2` 对应 Release `v1.0.1`）。

## 下载（直连）

打开 [Releases](https://github.com/xq219723/gendu/releases) 页面，进入最新版本即可下载附件：

| 平台 | 文件 | 说明 |
| --- | --- | --- |
| Android | `ShadowingAssistant_v1.0.1.apk` | 直接安装 |
| Windows x64 | `ShadowingAssistant_v1.0.1_windows_x64.zip` | 解压后运行 `程序/影子跟读助手.exe` |

> 大文件走 Release 附件分发：GitHub 普通仓库单文件上限 100 MB，而 APK 约 282 MB，无法用普通 git 提交。Release 附件支持直连下载，浏览器打开链接或 `curl -L` 均可。

## 后续如何上传新版本

1. 把新的 apk 和 zip 放进本目录（文件名带版本号，如 `ShadowingAssistant_v1.0.2.apk`）。
2. 确认 token 在 `C:/Users/Administrator/.github_token`（只有一行 token）。
3. 在 Git Bash 中执行：

   ```bash
   bash upload.sh 1.0.2
   ```

脚本会自动创建 `v1.0.2` Release 并把两个附件传上去，输出下载页面链接。

> 注意：token 不要提交到仓库（`.gitignore` 已排除）。若 token 泄露，请到 GitHub Settings → Tokens 撤销重建。
