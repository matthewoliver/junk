git clone http://github.com/matthewoliver/junk; git clone https://github.com/matthewoliver/vim_config; cd vim_config; ./setup.sh; cd -; cd junk/swift;sudo apt-get install liberasurecode-dev; bash saio.sh

cat > ~/.vimrc_overrides <<EOF
set term=screen-256color
let g:solarized_termcolors=256
set background=dark
" loading the solarized colorscheme is silent to prevent error during initial install
silent! colorscheme solarized
EOF

cat >> ~/.bashrc <<EOF
function git_branch() {
  git branch &> /dev/null
  if [ \$? -eq 0 ]
  then
    echo "(\$(git branch |grep -e ^* |awk '{print \$2}'))"
  fi
}
export PS1="\u@\h:\w\$(git_branch)\$ "
EOF

