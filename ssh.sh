#!/bin/bash

# 函数：检测 Linux 系统类型和版本
check_system() {
    echo -n "系统: 正在检测当前系统..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        tput cuu1  # 光标上移一行
        tput el     # 清除当前行
        echo "系统: $NAME $VERSION"
    else
        tput cuu1
        tput el
        echo "系统: 无法检测系统信息。"
    fi
}

# 函数：检测工具的安装状态
check_tools() {
    local tools
    tools=$(define_tools)
    local installed_tools=()
    local uninstalled_tools=()
    local tool_ids=()

    echo "检测常用工具及其描述："
    
    for tool in ${!tools[@]}; do
        if command -v "$tool" &> /dev/null; then
            installed_tools+=("$tool")
            echo "id (${#installed_tools[@]}) 已安装 $tool: ${tools[$tool]}"
        else
            uninstalled_tools+=("$tool")
            echo "id ($(( ${#installed_tools[@]} + ${#uninstalled_tools[@]} )) ) 未安装 $tool: ${tools[$tool]}"
        fi
        tool_ids+=("$tool")
    done

    handle_tool_selection tool_ids installed_tools
}

# 函数：处理工具选择
handle_tool_selection() {
    local tool_ids=("$@")
    read -p "请输入id选择工具: " id

    if [[ "$id" =~ ^[0-9]+$ ]] && [ "$id" -ge 1 ] && [ "$id" -le "${#tool_ids[@]}" ]; then
        local tool="${tool_ids[$id-1]}"
        if [[ " ${installed_tools[*]} " =~ " $tool " ]]; then
            manage_installed_tool "$tool"
        else
            install_tool "$tool"
        fi
    else
        echo "无效的ID，请输入正确的ID。"
    fi
}

# 函数：管理已安装工具
manage_installed_tool() {
    local tool="$1"
    echo "$tool 已安装。请选择操作："
    echo "1. 卸载"
    echo "2. 重装"
    read -p "请输入选项 (1/2): " option
    case $option in
        1)
            echo "正在卸载 $tool..."
            sudo apt-get remove "$tool"
            ;;
        2)
            echo "正在重装 $tool..."
            sudo apt-get install --reinstall "$tool"
            ;;
        *)
            echo "无效选项，请输入 1 或 2。"
            ;;
    esac
}

# 函数：安装未安装的工具
install_tool() {
    local tool="$1"
    echo "$tool 未安装。是否安装？"
    echo "1. 安装"
    read -p "请输入选项 (1): " option
    if [ "$option" == "1" ]; then
        echo "正在安装 $tool..."
        sudo apt-get install "$tool"
    else
        echo "无效选项，请输入 1。"
    fi
}

# 主菜单
main_menu() {
    while true; do
        echo "请选择要执行的操作："
        echo "1. 检测系统信息"
        echo "2. 检测常用工具"
        echo "3. 退出"
        read -p "请输入选项 (1-3): " option

        case $option in
            1)
                check_system
                ;;
            2)
                check_tools
                ;;
            3)
                echo "退出程序。"
                exit 0
                ;;
            *)
                echo "无效选项，请输入 1、2 或 3。"
                ;;
        esac
        echo ""  # 输出空行以便于阅读
    done
}

# 执行主菜单
main_menu

# 使用进程替换 <()，将 curl 下载的脚本作为临时文件执行，更稳定，适合大文件和复杂脚本
# bash <(curl -s https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh)

# 使用管道 | 直接将 curl 下载的脚本传递给 bash 执行，简洁但可能不如进程替换稳定
# curl -s https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh | bash