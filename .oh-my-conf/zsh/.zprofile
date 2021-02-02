# ~/.profile: executed by Bourne-compatible login shells.

if [ "$ZSH" ]; then
  if [ -f ~/.zshrc ]; then
    . ~/.zshrc
  fi
fi

mesg n 2> /dev/null || true
