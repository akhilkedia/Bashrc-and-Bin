# alias for nvm to work
alias sudo='sudo env PATH=$PATH:$NVM_BIN'

# Alias rm to trash-put
alias rm='trash-put'

# Alias man to open in browser
alias man='man --html=google-chrome'

# Alias screen
#alias myscreen='screen /dev/ttyUSB0 115200'

# Alias for watching nvidia usage
alias gpu='watch -n 0.5 nvidia-smi'

# Alias msi-keyboard backlight
alias light='msikeyboard -t rasta -i low'

# Get chart from Korbit
alias getkorbit='scp -r korbit:/home/ubuntu/btc-trade/stats /home/akhil/Akhil/trading'
