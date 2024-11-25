
#!/bin/bash

# 更新软件包列表
# sudo apt update

# 定义安装函数
install_package() {
    local package_name=$1
    sudo apt install -y "$package_name"
}

# 定义工具列表
declare -A tools
tools=(
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
    installed=()
    not_installed=()
    
    for tool in "${!tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            installed+=("$tool - ${tools[$tool]}")
        else
            not_installed+=("$tool - ${tools[$tool]}")
        fi
    done
}

# 询问用户是否检测常用工具
read -p "是否检测常用工具? (y/n): " check_tools
if [[ $check_tools == "y" ]]; then
    check_installed_tools

    # 显示已安装和未安装的工具列表
    echo -e "\n已安装的工具："
    if [ ${#installed[@]} -eq 0 ]; then
        echo "没有已安装的工具。"
    else
        printf '%s\n' "${installed[@]}"
    fi

    echo -e "\n未安装的工具："
    if [ ${#not_installed[@]} -eq 0 ]; then
        echo "所有工具均已安装。"
    else
        printf '%s\n' "${not_installed[@]}"
    fi
fi

# 询问用户是否要安装未安装的工具
read -p "是否安装未安装的工具? (y/n): " install_choice
if [[ $install_choice == "y" ]]; then
    for tool in "${not_installed[@]}"; do
        tool_name=$(echo "$tool" | cut -d' ' -f1)
        install_package "$tool_name"
    done
fi

# 完成
echo "安装过程已完成！"

# 这种是不好的, 会变成下载, 也就导致无法使用最新更新
# curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/.sh | bash

# 这种比较好
# bash <(curl -s https://raw.githubusercontent.com/myrouin/ssh/main/ssh.sh)
