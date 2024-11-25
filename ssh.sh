#!/bin/bash

# 更新软件包列表
# sudo apt update

# 定义安装函数
install_package() {
    sudo apt install -y "$1"
}

# 定义工具列表
declare -A tools=(
    ["curl"]="命令行工具，用于通过 URL 进行数据传输"
    ["git"]="分布式版本控制系统，用于跟踪文件的更改"
    ["python3-pip"]="Python 的包管理工具"
    ["nodejs"]="Node.js 的包管理工具"
    ["npm"]="Node.js 的包管理工具"
    ["snapd"]="软件包管理系统"
    ["vim"]="功能强大的命令行文本编辑器"
)

# 检测已安装的工具
check_installed_tools() {
    local installed=()
    local not_installed=()
    
    for tool in "${!tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            installed+=("$tool - ${tools[$tool]}")
        else
            not_installed+=("$tool - ${tools[$tool]}")
        fi
    done

    echo -e "\n已安装的工具："
    if [ ${#installed[@]} -eq 0 ]; then
        echo "没有已安装的工具。"
    else
        for i in "${!installed[@]}"; do
            echo "$((i + 1))) ${installed[i]}"
        done
    fi

    echo -e "\n未安装的工具："
    if [ ${#not_installed[@]} -eq 0 ]; then
        echo "所有工具均已安装。"
    else
        for i in "${!not_installed[@]}"; do
            echo "$((i + 1))) ${not_installed[i]}"
        done
    fi

    echo "${not_installed[@]}"  # 返回未安装的工具列表
}

# 询问用户是否检测常用工具
read -p "是否检测常用工具? (y/n): " check_tools
if [[ $check_tools == "y" ]]; then
    not_installed_tools=($(check_installed_tools))

    # 询问用户是否要安装未安装的工具
    read -p "输入未安装工具的ID进行安装，或输入 'all' 安装所有未安装的工具: " install_choice

    if [[ $install_choice == "all" ]]; then
        for tool in "${not_installed_tools[@]}"; do
            tool_name=$(echo "$tool" | cut -d' ' -f1)
            install_package "$tool_name"
        done
    elif [[ $install_choice =~ ^[0-9]+$ ]]; then
        index=$((install_choice - 1))
        if [[ $index -ge 0 && $index -lt ${#not_installed_tools[@]} ]]; then
            tool_name=$(echo "${not_installed_tools[$index]}" | cut -d' ' -f1)
            install_package "$tool_name"
        else
            echo "无效的选择！"
        fi
    else
        echo "无效的输入！"
    fi
fi

# 完成
echo "安装过程已完成！"

# 下载并运行最新的脚本
# bash <(curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh)

# 这种是不好的, 会变成下载, 也就导致无法使用最新更新
# curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/.sh | bash