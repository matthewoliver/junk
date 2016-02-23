git clone http://github.com/matthewoliver/junk; git clone https://github.com/matthewoliver/vim_config; cd vim_config; ./setup.sh; cd -; cd junk/swift;sudo apt-get install liberasurecode0 liberasurecode1 liberasurecode-dev; bash saio.sh


cat >> ~/.bashrc <<EOF
function git_branch() {
  git branch &> /dev/null
  if [ $? -eq 0 ]
  then
    echo "($(git branch |grep -e ^* |awk '{print $2}'))"
  fi
}
export PS1="\u@\h:\w\$(git_branch)\$ "
EOF

