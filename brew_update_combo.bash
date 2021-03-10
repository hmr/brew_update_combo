#!/usr/local/bin/bash

# brew_update_combo.bash
# One touch solution to upgrade Homebrew formulae and casks.
# https://github.com/hmr/brew_update_combo

function t_echo () {
  echo "----------------------------------------"
  echo "-> $1"
  echo "----------------------------------------"
}

t_echo "Updating BREW..."
brew update
echo

t_echo "Outdated formulae are..."
OUTDATED=$(brew outdated --formula | wc -l | sed -e 's/ //g')
if gtest ${OUTDATED} -eq 0; then
  echo "None."
  echo
else
  brew outdated --formula --verbose
  echo

  t_echo "Upgrading formulae..."
  brew upgrade --formula
  echo
fi

t_echo "Outdated casks are..."
OUTDATED_CASK=$(brew outdated --cask --greedy | wc -l | sed -e 's/ //g')
if gtest ${OUTDATED_CASK} -eq 0; then
  echo "None."
  echo
else
  brew outdated --cask --greedy --verbose
  #brew cask outdated
  echo

  t_echo "Upgrading casks..."
  brew upgrade --cask --greedy
  echo
fi

if gtest ${OUTDATED} -ne 0 -o ${OUTDATED_CASK} -ne 0; then
  t_echo "Cleaning up old files..."
  brew cleanup -s
  echo
fi

echo "DONE!"

