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

install_runner
