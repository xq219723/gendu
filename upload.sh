#!/usr/bin/env bash
# 后续上传命令：把新版本 apk/zip 发到 GitHub Release（可直连下载）
# 用法：在 Git Bash 里执行   bash upload.sh 1.0.2
# 前置：把新 apk 和 zip 放进本目录；token 放在 C:/Users/Administrator/.github_token
set -euo pipefail

VERSION="${1:?用法: bash upload.sh 1.0.2}"
TAG="v$VERSION"
OWNER="xq219723"
REPO="gendu"
TOKEN_FILE="C:/Users/Administrator/.github_token"
DIR="$(cd "$(dirname "$0")" && pwd)"

TOKEN="$(tr -d '\r\n' < "$TOKEN_FILE")"
API="https://api.github.com/repos/$OWNER/$REPO"

APK="$(find "$DIR" -maxdepth 1 -iname '*.apk' | head -1)"
ZIP="$(find "$DIR" -maxdepth 1 -iname '*.zip' | head -1)"
[ -n "$APK" ] || { echo "未找到 apk"; exit 1; }
[ -n "$ZIP" ] || { echo "未找到 zip"; exit 1; }

# 若该版本已存在，先拒绝（避免重复 tag 造成混乱）
HTTP=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" "$API/releases/tags/$TAG")
[ "$HTTP" = "200" ] && { echo "Release $TAG 已存在，请换版本号或先删除"; exit 1; }

echo "创建 Release $TAG ..."
REL="$(curl -sS -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  "$API/releases" \
  -d "{\"tag_name\":\"$TAG\",\"name\":\"$TAG\",\"body\":\"影子跟读助手 $VERSION\",\"draft\":false,\"prerelease\":false}")"
REL_ID="$(echo "$REL" | grep -m1 '"id"' | grep -o '[0-9]*')"
[ -n "$REL_ID" ] || { echo "$REL"; exit 1; }

for f in "$APK" "$ZIP"; do
  name="$(basename "$f")"
  case "$name" in
    *.apk) ct="application/vnd.android.package-archive" ;;
    *)     ct="application/zip" ;;
  esac
  echo "上传 $name ..."
  curl -sS -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: $ct" \
    --data-binary @"$f" \
    "https://uploads.github.com/repos/$OWNER/$REPO/releases/$REL_ID/assets?name=$name" \
    | grep -E '"browser_download_url"|"message"'
done

echo "完成：https://github.com/$OWNER/$REPO/releases/tag/$TAG"
