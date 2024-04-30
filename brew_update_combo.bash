#!env bash

# vim: set noet syn=bash ft=sh ff=unix fenc=utf-8 ts=2 sw=0 : # GPP default modeline for bash script
# shellcheck shell=bash disable=SC1091,SC2155,SC3010,SC3021,SC3037 source=${GPP_HOME}

# brew_update_combo.bash
# One touch solution to upgrade Homebrew formulae and casks.
# https://github.com/hmr/brew_update_combo

HOMEBREW_CONFDIR="${XDG_CONFIG_HOME:-${HOME}/.config}/homebrew"

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
if [[ ${OUTDATED} -eq 0 ]]; then
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
#OUTDATED_CASK=$(brew outdated --cask --greedy | wc -l | sed -e 's/ //g')
OUTDATED_CASK=$(brew outdated --cask | wc -l | sed -e 's/ //g')
if [[ ${OUTDATED_CASK} -eq 0 ]]; then
  echo "None."
  echo
else
  #brew outdated --cask --greedy --verbose
  brew outdated --cask --verbose
  echo

  t_echo "Upgrading casks..."
  #brew upgrade --cask --greedy
  brew upgrade --cask
  echo
fi

if [[ "${OUTDATED}" -ne 0 || "${OUTDATED_CASK}" -ne 0 ]]; then
  t_echo "Purging unnecessary files...."
  brew cleanup -s
  echo
fi

if [[ -d ${HOMEBREW_CONFDIR} ]]; then
    t_echo "Updating installed package list..."
    brew list --formula > "${HOMEBREW_CONFDIR}/installed_list_formulae.txt"
    brew list --casks   > "${HOMEBREW_CONFDIR}/installed_list_casks.txt"
    brew bundle dump --force --file "${HOMEBREW_CONFDIR}/Brewfile"
fi

echo "DONE!"

