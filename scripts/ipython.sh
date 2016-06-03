#!/usr/bin/env bash

if ! command -v jupyter > /dev/null; then
   pyenv install 3.5.1
   pyenv global 3.5.1
   pip install --upgrade pip
   pip install auxlib
   pip install conda
   conda install jupyter
fi
