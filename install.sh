#!/bin/bash

# =====================================
# 🧚‍♂️ 技術白話文翻譯 Skill - 自動安裝腳本
# =====================================
# 使用方式：把下面這行貼到終端機執行
# curl -sL https://raw.githubusercontent.com/miou1107/tech-translator/main/install.sh | bash
# =====================================

set -e

# 顏色定義（支援 ANSI）
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    GREEN=''
    YELLOW=''
    RED=''
    BLUE=''
    NC=''
fi

# 檢測作業系統
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macOS";;
        Linux*)     echo "Linux";;
        MINGW*|MSYS*|CYGWIN*) echo "Windows";;
        *)          echo "Unknown";;
    esac
}

OS=$(detect_os)

echo ""
echo "🧚‍♂️ 技術白話文翻譯 Skill - 自動安裝精靈"
echo "========================================"
echo "  偵測到系統：$OS"
echo ""

# 檢查 gh CLI
check_gh() {
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}✗${NC} 偵測不到 GitHub CLI (gh)"
        echo ""
        echo "請先安裝 gh CLI："
        case "$OS" in
            macOS)  echo "  brew install gh";;
            Linux)  echo "  brew install gh";;
            Windows) echo "  winget install GitHub.cli";;
        esac
        echo ""
        echo "安裝完成後再執行這個腳本"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} GitHub CLI 已安裝"
}

check_gh

# 安裝函數
install_skill() {
    local tool_name=$1
    local tool_path=$2
    
    if [ -d "$tool_path" ] || [ -d "$(dirname "$tool_path")" ]; then
        # 建立目錄
        mkdir -p "$tool_path" 2>/dev/null || true
        
        # 確保父目錄存在
        local parent_dir
        parent_dir=$(dirname "$tool_path")
        mkdir -p "$parent_dir" 2>/dev/null || true
        
        echo -e "${GREEN}✓${NC} 檢測到 $tool_name"
        
        # 如果已經有這個 skill，先移除
        if [ -d "$tool_path/tech-translator" ]; then
            echo -e "  ${YELLOW}!${NC} 移除舊版本..."
            rm -rf "$tool_path/tech-translator"
        fi
        
        # Clone
        if gh repo clone miou1107/tech-translator "$tool_path/tech-translator" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} 安裝完成！"
        else
            echo -e "  ${RED}✗${NC} 安裝失敗"
        fi
    fi
}

# 檢測各 AI 工具
echo ""
echo "🔍 檢測你的 AI 工具..."
echo ""

installed_count=0

# 根據作業系統設定 home 目錄
HOME_DIR="${HOME}"

# OpenCode
if [ -d "$HOME_DIR/.config/opencode" ] || [ -d "$HOME_DIR/.opencode" ]; then
    install_skill "OpenCode" "$HOME_DIR/.config/opencode/skills/skills"
    ((installed_count++))
fi

# Continue
if [ -d "$HOME_DIR/.continue" ]; then
    install_skill "Continue" "$HOME_DIR/.continue/skills"
    ((installed_count++))
fi

# Codex
if [ -d "$HOME_DIR/.codex" ]; then
    install_skill "Codex" "$HOME_DIR/.codex/skills"
    ((installed_count++))
fi

# Claude Code
if [ -d "$HOME_DIR/.claude" ]; then
    install_skill "Claude Code" "$HOME_DIR/.claude/skills"
    ((installed_count++))
fi

# Cursor
if [ -d "$HOME_DIR/.cursor" ]; then
    install_skill "Cursor" "$HOME_DIR/.cursor/skills"
    ((installed_count++))
fi

# Windsurf
if [ -d "$HOME_DIR/.windsurf" ]; then
    install_skill "Windsurf" "$HOME_DIR/.windsurf/skills"
    ((installed_count++))
fi

# Roo
if [ -d "$HOME_DIR/.roo" ]; then
    install_skill "Roo" "$HOME_DIR/.roo/skills"
    ((installed_count++))
fi

# Trae
if [ -d "$HOME_DIR/.trae" ]; then
    install_skill "Trae" "$HOME_DIR/.trae/skills"
    ((installed_count++))
fi

echo ""
echo "========================================"
echo ""

if [ $installed_count -eq 0 ]; then
    echo -e "${RED}✗${NC} 沒有檢測到支援的 AI 工具"
    echo ""
    echo "請確認你已經安裝以下其中一個 AI 工具："
    echo "  - OpenCode"
    echo "  - Continue (VS Code / JetBrains)"
    echo "  - Codex"
    echo "  - Claude Code"
    echo "  - Cursor"
    echo "  - Windsurf"
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
