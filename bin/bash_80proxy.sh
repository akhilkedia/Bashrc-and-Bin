#!/bin/bash
## Taken from https://github.com/frgomes/debian-bin/blob/master/bash_80proxy.sh
## see: http://askubuntu.com/questions/650941/how-to-set-global-proxy-in-ubuntu-from-configuration-url
##      http://askubuntu.com/questions/13963/call-script-after-connecting-to-a-wireless-network

function proxy_plugin_gsettings {
  if [ ! -z $(which gsettings) ] ;then
    if [ $(gsettings list-schemas | fgrep org.gnome.system.proxy | wc -l) == 5 ] ;then
      if [ -z "$proxy" ] ;then
        gsettings set org.gnome.system.proxy mode 'none'
        gsettings set org.gnome.system.proxy use-same-proxy true
        gsettings set org.gnome.system.proxy autoconfig-url ''
        gsettings set org.gnome.system.proxy ignore-hosts "['localhost','127.0.0.0/8','10.0.0.0/8','192.168.0.0/16','172.16.0.0/12','::1']"
        # first http
        gsettings set org.gnome.system.proxy.http host ''
        gsettings set org.gnome.system.proxy.http port 0
        gsettings set org.gnome.system.proxy.http enabled false
        gsettings set org.gnome.system.proxy.http use-authentication false
        gsettings set org.gnome.system.proxy.http authentication-user ''
        gsettings set org.gnome.system.proxy.http authentication-password ''
        # now other protocols
        for protocol in https socks ftp ;do
          gsettings set org.gnome.system.proxy.${protocol} host ''
          gsettings set org.gnome.system.proxy.${protocol} port 0
        done
      else
        local host=$(echo "$proxy" | cut -d/ -f3 | cut -d@ -f2 | cut -d: -f1)
        local port=$(echo "$proxy" | cut -d/ -f3 | cut -d@ -f2 | cut -d: -f2)
        local user=$(echo "$proxy" | cut -d/ -f3 | cut -d@ -f1 | cut -d: -f1)
        local pass=$(echo "$proxy" | cut -d/ -f3 | cut -d@ -f1 | cut -d: -f2)
        if [ "$user" == "$host" ]; then user="" ;fi
        if [ "$pass" == "$port" ]; then pass="" ;fi
        gsettings set org.gnome.system.proxy mode 'manual'
        gsettings set org.gnome.system.proxy use-same-proxy true
        gsettings set org.gnome.system.proxy autoconfig-url ''
        gsettings set org.gnome.system.proxy ignore-hosts "['localhost','127.0.0.0/8','10.0.0.0/8','192.168.0.0/16','172.16.0.0/12','::1','fc00::/7','fe80::/10']"
        # first http
        gsettings set org.gnome.system.proxy.http host "${host}"
        gsettings set org.gnome.system.proxy.http port "${port}"
        gsettings set org.gnome.system.proxy.http enabled true
	if [ -z "$user" ] ;then
          gsettings set org.gnome.system.proxy.http use-authentication false
          gsettings set org.gnome.system.proxy.http authentication-user ''
          gsettings set org.gnome.system.proxy.http authentication-password ''
        else
          gsettings set org.gnome.system.proxy.http use-authentication true
          gsettings set org.gnome.system.proxy.http authentication-user "$user"
          gsettings set org.gnome.system.proxy.http authentication-password "$pass"
        fi
        # now other protocols
        for protocol in https socks ftp ;do
          gsettings set org.gnome.system.proxy.${protocol} host "${host}"
          gsettings set org.gnome.system.proxy.${protocol} port "${port}"
        done
      fi
    fi
  fi
}

function proxy_plugin_environment {
  local proxy=$1
  if [ -z "$proxy" ] ;then
    grep PATH /etc/environment > /tmp/temp.t;
    sudo cat /tmp/temp.t > /etc/environment;
    rm /tmp/temp.t;
  else
    grep PATH /etc/environment > /tmp/temp.t;
    printf \
    "http_proxy=$proxy\n\
    https_proxy=$proxy\n\
    ftp_proxy=$proxy\n\
    no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n\
    HTTP_PROXY=$proxy\n\
    HTTPS_PROXY=$proxy\n\
    FTP_PROXY=$proxy\n\
    NO_PROXY=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n" >> /tmp/temp.t;
    cat /tmp/temp.t | sudo tee /etc/environment;
    rm /tmp/temp.t;
  fi
}

function proxy_plugin_apt {
  local proxy=$1
  if [ -z "$proxy" ] ;then
    [[ -f /etc/apt/apt.conf.d/80proxy ]] && sudo rm /etc/apt/apt.conf.d/80proxy && sudo touch /etc/apt/apt.conf.d/80proxy
  else
    sudo tee /etc/apt/apt.conf.d/80proxy > /dev/null << EOD
Acquire::http::Proxy  "$proxy";
Acquire::https::Proxy "$proxy";
Acquire::ftp::Proxy   "$proxy";
EOD
  fi
  # make sure we remove references eventually present in /etc/apt/apt.conf
  if [ -f /etc/apt/apt.conf ] ;then
    cat /etc/apt/apt.conf | \
      fgrep -v Acquire::http::Proxy | fgrep -v Acquire::https::Proxy | fgrep -v Acquire::ftp::Proxy | \
        sudo tee /etc/apt/apt.conf > /dev/null
  fi
}

function proxy_plugin_shell {
  local proxy=$1
  if [ -z "$proxy" ] ;then
    for var in http_proxy https_proxy ftp_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY ;do
      unset $var
    done
    
  else
    for var in http_proxy https_proxy ftp_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ;do
      export $var=$proxy
    done
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
  fi
}

function proxy_plugin_npm {
  local proxy=$1
  if [ -z "$proxy" ] ;then
    unset npm_config_proxy
    unset npm_config_https_proxy
  else
    export npm_config_proxy="$proxy"
    export npm_config_https_proxy="$proxy"
  fi
}

function proxy_plugin_java {
  local proxy=$1
  if [ -z "$proxy" ] ;then
    unset JAVA_OPTS_PROXY
  else
    local host=$(echo $proxy | cut -d/ -f3 | cut -d: -f1)
    local port=$(echo $proxy | cut -d/ -f3 | cut -d: -f2)
    export JAVA_OPTS_PROXY="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port}"
  fi
}

function proxy_plugin_wget {
  local proxy=$1
  if [ -z "$proxy" ] ;then
    sudo sed -i "/use_proxy=/d" /etc/wgetrc
    sudo sed -i "/http_proxy=/d" /etc/wgetrc
  else
    printf "use_proxy=yes\nhttp_proxy=$proxy\n" | sudo tee -a /etc/wgetrc;
  fi
}


#-------------------------------------------------------------------------------------------------------


function proxy_finder {
  if [ $(netstat -an | fgrep 8080 | wc -l) -gt 0 ] ;then
    ip=$(netstat -an | fgrep ":8080 " | head -1 | sed -r 's/[ \t]+/ /g' | cut -d' ' -f5 | cut -d: -f1)
    if [[ -z "$ip" ]] ;then
      echo "http://localhost:8080"
    else
      echo "http://${ip}:8080"
    fi
  else
    fgrep http_proxy /etc/environment | cut -d= -f2
  fi
}


#-------------------------------------------------------------------------------------------------------


function proxy_status {
  [[ -f /etc/environment ]] && cat /etc/environment
}

function proxy_on {
  local proxy=http://10.112.1.184:8080/
  proxy_plugin_gsettings
  proxy_plugin_environment "$proxy"
  proxy_plugin_apt         "$proxy"
  proxy_plugin_shell       $proxy
  proxy_plugin_npm         "$proxy"
  proxy_plugin_java        "$proxy"
  proxy_plugin_wget        "$proxy"
}

function proxy_off {
  proxy_plugin_gsettings
  proxy_plugin_environment
  proxy_plugin_apt
  proxy_plugin_shell
  proxy_plugin_npm
  proxy_plugin_java
  proxy_plugin_wget
}

if [ "$1" == "on" ]; then
  proxy_on
else
  proxy_off
fi

