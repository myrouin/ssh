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

# 函数：检测常用工具及其描述
check_tools() {
    # 定义常用工具及其描述
    declare -A tools
    tools=(
        ["curl"]="一个命令行工具，用于与服务器进行数据传输，支持多种协议。"
        ["wget"]="一个用于从网络上下载文件的命令行工具，支持递归下载和断点续传。"
        ["git"]="一个分布式版本控制系统，用于跟踪文件的更改，特别是源代码。"
        ["vim"]="一个强大的文本编辑器，适用于编程和文本编辑，功能丰富。"
        ["nano"]="一个简单易用的文本编辑器，适合初学者和快速编辑。"
        ["htop"]="一个交互式进程查看器，提供系统资源使用情况的实时监控。"
        ["docker"]="一个用于自动化应用程序部署的容器化平台。"
        ["python3"]="Python 编程语言的版本，广泛用于开发和脚本编写。"
        ["node"]="JavaScript 运行时，常用于构建网络应用。"
        ["java"]="一种广泛使用的编程语言，适用于多种平台。"
    )

    echo "检测常用工具及其描述："
    installed_tools=()
    uninstalled_tools=()

    # 检测每个工具
    for tool in "${!tools[@]}"; do
        echo "$tool: ${tools[$tool]}"
        if command -v "$tool" &> /dev/null; then
            echo "状态: 已安装"
            installed_tools+=("$tool")
        else
            echo "状态: 未安装"
            uninstalled_tools+=("$tool")
        fi
        echo ""  # 输出空行以便于阅读
    done

    # 处理已安装的工具
    for tool in "${installed_tools[@]}"; do
        read -p "是否重装 $tool? (y/n): " reinstall
        if [[ "$reinstall" == "y" ]]; then
            echo "正在重装 $tool..."
            sudo apt-get install --reinstall "$tool"
        fi
    done

    # 处理未安装的工具
    for tool in "${uninstalled_tools[@]}"; do
        read -p "是否安装 $tool? (y/n): " install
        if [[ "$install" == "y" ]]; then
            echo "正在安装 $tool..."
            sudo apt-get install "$tool"
        fi
    done
}

# 主菜单
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



# 使用进程替换 <()，将 curl 下载的脚本作为临时文件执行，更稳定，适合大文件和复杂脚本
# bash <(curl -s https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh)

# 使用管道 | 直接将 curl 下载的脚本传递给 bash 执行，简洁但可能不如进程替换稳定
# curl -s https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh | bash