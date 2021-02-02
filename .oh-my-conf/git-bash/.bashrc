[ -f "/c/Users/ZYJ/bin/win-sudo/s/path.sh" ] && source "/c/Users/ZYJ/bin/win-sudo/s/path.sh"

# cd D:/Documents/1code

# nvm
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# CUSTOM MIRRORS

# HOST_IP 是Windows的物理IP
export HOST_IP=127.0.0.1
export PORXY_ADDR="http://$HOST_IP:7890"

# PROXY FOR APT
function proxy_apt() {
    # make sure apt.conf existed
    sudo touch /etc/apt/apt.conf
    sudo sed -i '/^Acquire::https\?::Proxy/d' /etc/apt/apt.conf
    # add proxy
    echo -e "Acquire::http::Proxy \"$PORXY_ADDR\";\nAcquire::https::Proxy \"$PORXY_ADDR\";" | sudo tee -a /etc/apt/apt.conf >/dev/null
    echo "current apt proxy status: using $PORXY_ADDR, proxying"
}

function unproxy_apt() {
    sudo sed -i '/^Acquire::https\?::Proxy/d' /etc/apt/apt.conf
    echo "current apt proxy status: direct connect, not proxying"
}

# PROXY FOR NPM
function proxy_yarn() {
    yarn config set proxy $PORXY_ADDR
    yarn config set https-proxy $PORXY_ADDR
    npm config set proxy $PORXY_ADDR
    npm config set https-proxy $PORXY_ADDR
}

function unproxy_yarn() {
    yarn config delete proxy
    yarn config delete https-proxy
    npm config delete proxy
    npm config delete https-proxy
}

function proxy_npm() {
    proxy_yarn
}

function unproxy_npm() {
    unproxy_yarn
}

# GLOBAL PROXY FOR BASH

# if ~/.bash_proxy not exist , then create it.
if [ ! -f ~/.bash_proxy ]; then
    touch ~/.bash_proxy
fi
# execute ~/.bash_proxy
. ~/.bash_proxy

function proxy() {
    echo -e "export {all_proxy,http_proxy,https_proxy,ALL_PROXY,HTTP_PROXY,HTTPS_PROXY}=\"$PORXY_ADDR\";" | tee ~/.bash_proxy >/dev/null
    # apply
    . ~/.bash_proxy
    # declare
    echo "current proxy status: using $PORXY_ADDR, proxying"
}

function unproxy() {
    # unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY
    echo -e "unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY" | tee ~/.bash_proxy >/dev/null
    # apply
    . ~/.bash_proxy
    # declare
    echo "current proxy status:  direct connect, not proxying"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
