#!/bin/bash

echo # 进行换行
echo -e "=========================================================================="
echo -e "=                                                                        ="
echo -e "=                欢迎使用 Rouin-Linux 工具                               ="
echo -e "=                                                                        ="
echo -e "==========================================================================\n"

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

    # 动态生成工具的ID并检测每个工具
    id=1
    for tool in "${!tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            status="已安装"
        else
            status="未安装"
        fi
        echo -e "$id: $status $tool: ${tools[$tool]}\n"
        ((id++))
    done

    # 提供用户选择
    read -p "请输入工具的编号以进行操作（安装/卸载/重装），或输入 'exit' 退出: " tool_id

    if [[ "$tool_id" == "exit" ]]; then
        return
    fi

    # 根据输入的ID查找工具名称
    tool_name=$(echo "${!tools[@]}" | cut -d' ' -f"$tool_id")

    if [[ -n "$tool_name" ]]; then
        if command -v "$tool_name" &> /dev/null; then
            echo "$tool_name 已安装。"
            read -p "选择操作: 1. 卸载 2. 重装: " action
            case $action in
                1)
                    echo "正在卸载 $tool_name..."
                    sudo apt remove -y "$tool_name"  # 适用于 Debian/Ubuntu 系统
                    ;;
                2)
                    echo "正在重装 $tool_name..."
                    sudo apt install --reinstall -y "$tool_name"  # 适用于 Debian/Ubuntu 系统
                    ;;
                *)
                    echo "无效选项。"
                    ;;
            esac
        else
            echo "$tool_name 未安装。"
            read -p "选择操作: 1. 安装: " action
            case $action in
                1)
                    echo "正在安装 $tool_name..."
                    sudo apt install -y "$tool_name"  # 适用于 Debian/Ubuntu 系统
                    ;;
                *)
                    echo "无效选项。"
                    ;;
            esac
        fi
    else
        echo "未找到该工具，请检查输入。"
    fi
}

# 主菜单
while true; do
    echo -e "请选择要执行的操作：\n"
    echo -e "1. 检测系统信息\n"
    echo -e "2. 检测常用工具\n"
    echo -e "3. 退出\n"
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
# bash <(curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh)


# 使用管道 | 直接将 curl 下载的脚本传递给 bash 执行，简洁但可能不如进程替换稳定
# curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh | bash

# rm -f /tmp/ssh.sh && curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh -o /tmp/ssh.sh && bash /tmp/ssh.sh
