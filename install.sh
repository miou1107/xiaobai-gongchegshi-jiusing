#!/bin/bash

# =====================================
# 🧚‍♂️ 技術白話文翻譯 Skill - 自動安裝腳本
# =====================================
# 使用方式：把下面這行貼到終端機執行
# curl -sL https://raw.githubusercontent.com/miou1107/tech-translator/main/install.sh | bash
# =====================================

set -e

# 顏色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "🧚‍♂️ 技術白話文翻譯 Skill - 自動安裝精靈"
echo "========================================"
echo ""

# 檢測並建立目錄、安裝
install_skill() {
    local tool_name=$1
    local tool_path=$2
    
    if [ -d "$tool_path" ]; then
        echo -e "${GREEN}✓${NC} 檢測到 $tool_name"
        
        # 建立 skills 目錄
        mkdir -p "$tool_path"
        
        # 如果已經有這個 skill，先移除
        if [ -d "$tool_path/tech-translator" ]; then
            echo -e "  ${YELLOW}!${NC} 移除舊版本..."
            rm -rf "$tool_path/tech-translator"
        fi
        
        # Clone
        gh repo clone miou1107/tech-translator "$tool_path/tech-translator" 2>/dev/null || {
            echo -e "  ${RED}✗${NC} 安裝失敗，請確認已安裝 gh CLI"
            return 1
        }
        
        echo -e "  ${GREEN}✓${NC} 安裝完成！"
    fi
}

# 檢測各 AI 工具
echo "🔍 檢測你的 AI 工具..."

installed_count=0

# OpenCode
if [ -d "$HOME/.config/opencode" ]; then
    install_skill "OpenCode" "$HOME/.config/opencode/skills/skills"
    ((installed_count++))
fi

# Continue
if [ -d "$HOME/.continue" ]; then
    install_skill "Continue" "$HOME/.continue/skills"
    ((installed_count++))
fi

# Codex
if [ -d "$HOME/.codex" ]; then
    install_skill "Codex" "$HOME/.codex/skills"
    ((installed_count++))
fi

# Claude Code
if [ -d "$HOME/.claude" ]; then
    install_skill "Claude Code" "$HOME/.claude/skills"
    ((installed_count++))
fi

# Cursor
if [ -d "$HOME/.cursor" ]; then
    install_skill "Cursor" "$HOME/.cursor/skills"
    ((installed_count++))
fi

# Windsurf
if [ -d "$HOME/.windsurf" ]; then
    install_skill "Windsurf" "$HOME/.windsurf/skills"
    ((installed_count++))
fi

# Roo
if [ -d "$HOME/.roo" ]; then
    install_skill "Roo" "$HOME/.roo/skills"
    ((installed_count++))
fi

# Trae
if [ -d "$HOME/.trae" ]; then
    install_skill "Trae" "$HOME/.trae/skills"
    ((installed_count++))
fi

echo ""
echo "========================================"
echo ""

if [ $installed_count -eq 0 ]; then
    echo -e "${RED}✗${NC} 沒有檢測到支援的 AI 工具"
    echo ""
    echo "請確認你已經安裝以下其中一個 AI 工具："
    echo "- OpenCode"
    echo "- Continue (VS Code / JetBrains)"
    echo "- Codex"
    echo "- Claude Code"
    echo "- Cursor"
    echo "- Windsurf"
    exit 1
else
    echo -e "${GREEN}🎉${NC} 安裝完成！已安裝到 $installed_count 個 AI 工具"
    echo ""
    echo "📝 使用方式："
    echo "  /翻譯  - 對當前對話做白話翻譯"
    echo "  /評測  - 測驗你的技術等級"
    echo "  /等級  - 查看當前等級"
    echo ""
    echo "🧚‍♂️ 重新啟動你的 AI 工具就可以開始使用了！"
fi

echo ""
