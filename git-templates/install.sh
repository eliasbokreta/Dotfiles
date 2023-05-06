#!/bin/bash

mkdir -p ~/.git-templates/hooks
git config --global core.hooksPath "$HOME/.git-templates/hooks"
chmod a+x ~/.git-templates/hooks/pre-commit
