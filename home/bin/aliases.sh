# colours
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# alias for git without proxy
alias pgit='HTTP_PROXY="" HTTPS_PROXY="" FTP_PROXY="" http_proxy="" https_proxy="" ftp_proxy="" git'

# alias for nvm to work
alias sudo='sudo env PATH=$PATH:$NVM_BIN'

# Alias rm to trash-put
(command -v trash-put >/dev/null 2>&1) && alias rm='trash-put'

# Alias man to open in browser
(command -v google-chrome >/dev/null 2>&1) && alias mann='man --html=google-chrome'

# Alias msi-keyboard backlight
alias light='msikeyboard -t rasta -i low'

# Get chart from Korbit
alias getkorbit='scp -r korbit:/home/ubuntu/btc-trade/stats /home/akhil/Akhil/trading'

# sshfs supercom
alias supmount='sudo sshfs -o IdentityFile=~/.ssh/id_rsa -o allow_other -o reconnect -o max_readahead=90000 -o big_writes akhil.kedia@202.20.185.100:/home/sr5/akhil.kedia/ /home/akhil/sup/'
alias supunmount='sudo umount /home/akhil/sup'

# Supercom aliases
alias wsmi='watch -n 0.5 nvidia-smi'
alias wmyjobs='watch -n 0.5 "bjobs -o \"id:8 queue:13 stat:5 submit_time:15 exec_host:15 name:40 sub_cwd\" |  sort -r"'
alias myjobs='bjobs -o "id:8 queue:13 stat:5 submit_time:15 exec_host:15 name:40 sub_cwd" |  sort -r'
alias queuestats='bqueues -w -u akhil.kedia | head -n 1; bqueues -w -u akhil.kedia | grep _gpu | grep ^s'
alias diskusage='/usr/lpp/mmfs/bin/mmlsquota -j diva  gpfs.ml1 --block-size=G'
alias teamjobs='busers $(bugroup swc2_ug)'