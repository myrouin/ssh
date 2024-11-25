
#!/bin/bash

# 更新软件包列表
# sudo apt update

echo "ssh使用时命令"

# 安装 curl
read -p "安装 curl（命令行工具，用于通过 URL 进行数据传输）? (y/n): " install_curl
if [[ $install_curl == "y" ]]; then
    sudo apt install -y curl
fi

# 安装 git
read -p "安装 git（分布式版本控制系统，用于跟踪文件的更改）? (y/n): " install_git
if [[ $install_git == "y" ]]; then
    sudo apt install -y git
fi

# 安装 pip
read -p "安装 pip（Python 的包管理工具）? (y/n): " install_pip
if [[ $install_pip == "y" ]]; then
    sudo apt install -y python3-pip
fi

# 安装 npm（Node.js 和 npm）
read -p "安装 npm（Node.js 的包管理工具）? (y/n): " install_npm
if [[ $install_npm == "y" ]]; then
    sudo apt install -y nodejs npm
fi

# 安装 snapd
read -p "安装 snap（软件包管理系统）? (y/n): " install_snap
if [[ $install_snap == "y" ]]; then
    sudo apt install -y snapd
fi

# 安装 vim
read -p "安装 vim（功能强大的命令行文本编辑器）? (y/n): " install_vim
if [[ $install_vim == "y" ]]; then
    sudo apt install -y vim
fi

# 完成
echo "安装过程已完成！"

# ssh使用时命令
# curl -sSL https://raw.githubusercontent.com/myrouin/ssh/main/.sh | bash