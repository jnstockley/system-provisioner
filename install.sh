#!/bin/bash

function url_builder() {
    VERSION="2.304.0"
    OS=$(uname)
    arch=$(uname -m)


    if [ $OS = "Darwin" ] 
    then
        OS="osx"
    elif [ $OS = "Linux" ] 
    then
        echo "linux"
    else
        OS=""
        echo "Unsupported OS"
        exit 1
    fi

    if [ $arch = "x86_64" ]
    then
        arch="x64"
    elif [ $arch = "arm" ]
    then
        arch="arm"
    elif [ $arch = "arm64" ] || [ $arch = "aarch64" ]
    then
        arch="arm64"
    else
        arch=""
        echo "Unsupported System Architecture"
        exit 1
    fi

    echo "https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-${OS}-${arch}-${VERSION}.tar.gz" "actions-runner-${OS}-${arch}-${VERSION}.tar.gz"
}

function install_runner(){
    # Delete old directory if present
    rm -rf actions-runner

    read URL OUTPUTFILE < <(url_builder)

    # Create a folder
    mkdir actions-runner && cd actions-runner

    # Download the latest runner package
    curl -O -L $URL

    # Extract the installer
    tar xzf $OUTPUTFILE  
}

function configure_runner(){
    read -p "Enter GitHub Username: " GITHUB_USERNAME
    read -p "Enter GitHub Repo Name: " GITHUB_REPO
    echo "Runner Token found here: https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO}/settings/actions/runners/new"
    read -p "Enter Runner Token: " GITHUB_RUNNER_TOKEN
    
    # Set config to executable
    chmod +x config.sh
    ./config.sh --url "https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO}" --token $GITHUB_RUNNER_TOKEN

    # Set svc to executable
    chmod +x svc.sh

    # Install as service
    sudo ./svc.sh install

    # Start svc service
    sudo ./svc.sh start

}

install_runner

configure_runner
