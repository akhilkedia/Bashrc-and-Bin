#!/usr/bin/env bash

# How to use - At line 191, edit the variable "proxy" and "cert" in the function "proxy_on"
# Call this script with "sudo ./bash_80proxy.sh on" to turn on proxy settings, "sudo ./bash_80proxy.sh" to turn proxy off.
# Logout and login for changes to take effect.

PROXY_PROFILE_FILE="/etc/profile.d/proxy.sh"

function proxy_plugin_gsettings() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        gsettings set org.gnome.system.proxy mode 'none'
        gsettings set org.gnome.system.proxy use-same-proxy true
        gsettings set org.gnome.system.proxy autoconfig-url ''
        gsettings set org.gnome.system.proxy ignore-hosts "['localhost','127.0.0.0/8','10.0.0.0/8','192.168.0.0/16','172.16.0.0/12','::1']"
        # first http
        gsettings set org.gnome.system.proxy.http host ''
        gsettings set org.gnome.system.proxy.http port 0
        gsettings set org.gnome.system.proxy.http enabled false
        # gsettings set org.gnome.system.proxy.http use-authentication false
        # gsettings set org.gnome.system.proxy.http authentication-user ''
        # gsettings set org.gnome.system.proxy.http authentication-password ''
        # now other protocols
        for protocol in https socks ftp; do
            gsettings set org.gnome.system.proxy.${protocol} host ''
            gsettings set org.gnome.system.proxy.${protocol} port 0
        done
    else
        local host=$(echo "$proxy" | cut -d/ -f3 | cut -d@ -f2 | cut -d: -f1)
        local port=$(echo "$proxy" | cut -d/ -f3 | cut -d@ -f2 | cut -d: -f2)
        gsettings set org.gnome.system.proxy mode 'manual'
        gsettings set org.gnome.system.proxy use-same-proxy true
        gsettings set org.gnome.system.proxy autoconfig-url ''
        gsettings set org.gnome.system.proxy ignore-hosts "['localhost','127.0.0.0/8','10.0.0.0/8','192.168.0.0/16','172.16.0.0/12','::1','fc00::/7','fe80::/10']"
        # first http
        gsettings set org.gnome.system.proxy.http host "${host}"
        gsettings set org.gnome.system.proxy.http port "${port}"
        gsettings set org.gnome.system.proxy.http enabled true
        # gsettings set org.gnome.system.proxy.http use-authentication false
        # gsettings set org.gnome.system.proxy.http authentication-user ''
        # gsettings set org.gnome.system.proxy.http authentication-password ''
        # now other protocols
        for protocol in https socks ftp; do
            gsettings set org.gnome.system.proxy.${protocol} host "${host}"
            gsettings set org.gnome.system.proxy.${protocol} port "${port}"
        done
    fi
}

function proxy_plugin_environment() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        sudo rm $PROXY_PROFILE_FILE
    else
		sudo tee -a $PROXY_PROFILE_FILE >/dev/null <<EOD
export http_proxy="$proxy"
export https_proxy="$proxy"
export ftp_proxy="$proxy"
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
export HTTP_PROXY="$proxy"
export HTTPS_PROXY="$proxy"
export FTP_PROXY="$proxy"
export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
EOD
    fi
}

function proxy_plugin_apt() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        [[ -f /etc/apt/apt.conf.d/80proxy ]] && sudo rm /etc/apt/apt.conf.d/80proxy && sudo touch /etc/apt/apt.conf.d/80proxy
    else
		sudo tee /etc/apt/apt.conf.d/80proxy >/dev/null <<EOD
Acquire::http::Proxy  "$proxy";
Acquire::https::Proxy "$proxy";
Acquire::ftp::Proxy   "$proxy";
EOD
    fi
    # make sure we remove references eventually present in /etc/apt/apt.conf
    if [ -f /etc/apt/apt.conf ]; then
        cat /etc/apt/apt.conf |
        fgrep -v Acquire::http::Proxy | fgrep -v Acquire::https::Proxy | fgrep -v Acquire::ftp::Proxy |
        sudo tee /etc/apt/apt.conf >/dev/null
    fi
}

function proxy_plugin_shell() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        for var in http_proxy https_proxy ftp_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY; do
            unset $var
        done

    else
        for var in http_proxy https_proxy ftp_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY; do
            export $var=$proxy
        done
        export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
        export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
    fi
}

function proxy_plugin_npm() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        unset npm_config_proxy
        unset npm_config_https_proxy
    else
        export npm_config_proxy="$proxy"
        printf "export npm_config_proxy=\"$npm_config_proxy\"\n" | sudo tee -a $PROXY_PROFILE_FILE
        export npm_config_https_proxy="$proxy"
        printf "export npm_config_https_proxy=\"$npm_config_https_proxy\"\n" | sudo tee -a $PROXY_PROFILE_FILE
    fi
}

function proxy_plugin_java_maven() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        unset JAVA_OPTS_PROXY
        unset MAVEN_OPTS
    else
        local host=$(echo $proxy | cut -d/ -f3 | cut -d: -f1)
        local port=$(echo $proxy | cut -d/ -f3 | cut -d: -f2)
        export JAVA_OPTS_PROXY="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port}"
        printf "export JAVA_OPTS_PROXY=\"$JAVA_OPTS_PROXY\"\n" | sudo tee -a $PROXY_PROFILE_FILE
        export MAVEN_OPTS="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port} -Dhttps.proxyHost=${host} -Dhttps.proxyPort=${port}"
        printf "export MAVEN_OPTS=\"$MAVEN_OPTS\"\n" | sudo tee -a $PROXY_PROFILE_FILE
    fi
}

function proxy_plugin_wget() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        sudo sed -i "/use_proxy=/d" /etc/wgetrc
        sudo sed -i "/http_proxy=/d" /etc/wgetrc
    else
        printf "use_proxy=yes\nhttp_proxy=$proxy\n" | sudo tee -a /etc/wgetrc
    fi
}

function proxy_plugin_pip() {
    local proxy=$1
    if [ -z "$proxy" ]; then
        sudo sed -i '/cert=/{s/.*//;x;d;};x;p;${x;p;}' /etc/pip.conf
    else
        printf "[global]\ncert=/usr/local/share/ca-certificates/proxy.crt\n" | sudo tee -a /etc/pip.conf
    fi
}

function proxy_plugin_cert() {
    local cert=$1
    if [ -z "$cert" ]; then
        sudo rm "/usr/local/share/ca-certificates/proxy.crt"
        sudo update-ca-certificates
    else
        sudo cp $cert "/usr/local/share/ca-certificates/proxy.crt"
        sudo update-ca-certificates
    fi
}

# function proxy_finder {
#   if [ $(netstat -an | fgrep 8080 | wc -l) -gt 0 ] ;then
#     ip=$(netstat -an | fgrep ":8080 " | head -1 | sed -r 's/[ \t]+/ /g' | cut -d' ' -f5 | cut -d: -f1)
#     if [[ -z "$ip" ]] ;then
#       echo "http://localhost:8080"
#     else
#       echo "http://${ip}:8080"
#     fi
#   else
#     fgrep http_proxy /etc/environment | cut -d= -f2
#   fi
# }

# function proxy_status {
#   [[ -f /etc/environment ]] && cat /etc/environment
# }

function proxy_on() {
    # Proxy server and port for your location
    local proxy=http://10.112.1.184:8080/
    # Samsung proxy CA certificate
    local cert=/home/akhil/Documents/srnd.crt
    proxy_plugin_gsettings "$proxy"
    proxy_plugin_environment "$proxy"
    proxy_plugin_apt "$proxy"
    proxy_plugin_shell $proxy
    proxy_plugin_cert "$cert"
    proxy_plugin_npm "$proxy"
    proxy_plugin_java_maven "$proxy"
    proxy_plugin_wget "$proxy"
    proxy_plugin_pip "$proxy"
}

function proxy_off() {
    proxy_plugin_gsettings
    proxy_plugin_environment
    proxy_plugin_apt
    proxy_plugin_shell
    proxy_plugin_cert
    proxy_plugin_npm
    proxy_plugin_java_maven
    proxy_plugin_wget
    proxy_plugin_pip
}

if [ "$1" == "on" ]; then
    proxy_on
else
    proxy_off
fi
