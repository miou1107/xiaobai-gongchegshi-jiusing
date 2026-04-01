#!/bin/bash

# =====================================
# 🧚‍♂️ 小白工程師救星 - 自動安裝腳本
# =====================================
# 使用方式：在 AI 中輸入以下 prompt
# 請幫我安裝「小白工程師救星」skill
# curl -sL https://raw.githubusercontent.com/miou1107/xiaobai-gongchegshi-jiusing/main/install.sh | bash
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
echo "🧚‍♂️ 小白工程師救星 - 自動安裝精靈"
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

# 安裝函數 - 用符號連結（節省空間）
install_skill_symlink() {
    local tool_name=$1
    local tool_path=$2
    local source_path=$3
    
    if [ -d "$tool_path" ] || [ -d "$(dirname "$tool_path")" ]; then
        # 建立目錄
        mkdir -p "$tool_path" 2>/dev/null || true
        
        # 確保父目錄存在
        local parent_dir
        parent_dir=$(dirname "$tool_path")
        mkdir -p "$parent_dir" 2>/dev/null || true
        
        echo -e "${GREEN}✓${NC} 檢測到 $tool_name"
        
        # 如果已經有這個 skill，先移除
        if [ -L "$tool_path/小白工程師救星" ] || [ -d "$tool_path/小白工程師救星" ]; then
            echo -e "  ${YELLOW}!${NC} 移除舊版本..."
            rm -rf "$tool_path/小白工程師救星"
        fi
        
        # 建立符號連結
        if ln -s "$source_path" "$tool_path/小白工程師救星" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} 安裝完成！"
            return 0
        else
            echo -e "  ${RED}✗${NC} 安裝失敗"
            return 1
        fi
    fi
    return 1
}

# 安裝函數 - 用 gh repo clone
install_skill_clone() {
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
        if [ -L "$tool_path/小白工程師救星" ] || [ -d "$tool_path/小白工程師救星" ]; then
            echo -e "  ${YELLOW}!${NC} 移除舊版本..."
            rm -rf "$tool_path/小白工程師救星"
        fi
        
        # Clone
        if gh repo clone miou1107/xiaobai-gongchegshi-jiusing "$tool_path/小白工程師救星" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} 安裝完成！"
            return 0
        else
            echo -e "  ${RED}✗${NC} 安裝失敗"
            return 1
        fi
    fi
    return 1
}

# 更新 OpenCode skills-lock.json
update_opencode_config() {
    local lock_file="$HOME_DIR/.config/opencode/skills/skills-lock.json"
    
    if [ -f "$lock_file" ]; then
        # 檢查是否已經有小白工程師救星
        if grep -q '"小白工程師救星"' "$lock_file"; then
            echo -e "  ${GREEN}✓${NC} OpenCode 設定已存在"
        else
            # 使用臨時檔案更新 JSON
            local temp_file=$(mktemp)
            # 讀取並更新 JSON
            python3 - << PYTHON_EOF
import json
with open("$lock_file", "r") as f:
    data = json.load(f)
if "skills" not in data:
    data["skills"] = {}
if "小白工程師救星" not in data["skills"]:
    data["skills"]["小白工程師救星"] = {
        "source": "miou1107/xiaobai-gongchegshi-jiusing",
        "sourceType": "github",
        "computedHash": "local"
    }
    with open("$lock_file", "w") as f:
        json.dump(data, f, indent=2)
PYTHON_EOF
            echo -e "  ${GREEN}✓${NC} OpenCode 設定已更新"
            echo -e "  ${YELLOW}!${NC} 請重新啟動 OpenCode 讓 skill 生效"
        fi
    fi
}

# 檢測各 AI 工具
echo ""
echo "🔍 檢測你的 AI 工具..."
echo ""

installed_count=0
HOME_DIR="${HOME}"

# OpenCode - 需要設定 skills-lock.json
if [ -d "$HOME_DIR/.config/opencode" ]; then
    if install_skill_clone "OpenCode" "$HOME_DIR/.config/opencode/skills/skills/小白工程師救星"; then
        ((installed_count++))
        update_opencode_config
    fi
fi

# Continue
if [ -d "$HOME_DIR/.continue" ]; then
    if install_skill_clone "Continue" "$HOME_DIR/.continue/skills/小白工程師救星"; then
        ((installed_count++))
    fi
fi

# Codex
if [ -d "$HOME_DIR/.codex" ]; then
    if install_skill_clone "Codex" "$HOME_DIR/.codex/skills/小白工程師救星"; then
        ((installed_count++))
    fi
fi

# Claude Code
if [ -d "$HOME_DIR/.claude" ]; then
    if install_skill_clone "Claude Code" "$HOME_DIR/.claude/skills/小白工程師救星"; then
        ((installed_count++))
    fi
fi

# Cursor
if [ -d "$HOME_DIR/.cursor" ]; then
    if install_skill_clone "Cursor" "$HOME_DIR/.cursor/skills/小白工程師救星"; then
        ((installed_count++))
    fi
fi

# Windsurf
if [ -d "$HOME_DIR/.windsurf" ]; then
    if install_skill_clone "Windsurf" "$HOME_DIR/.windsurf/skills/小白工程師救星"; then
        ((installed_count++))
    fi
fi

# Roo
if [ -d "$HOME_DIR/.roo" ]; then
    if install_skill_clone "Roo" "$HOME_DIR/.roo/skills/小白工程師救星"; then
        ((installed_count++))
    fi
fi

# Trae
if [ -d "$HOME_DIR/.trae" ]; then
    if install_skill_clone "Trae" "$HOME_DIR/.trae/skills/小白工程師救星"; then
        ((installed_count++))
    fi
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
