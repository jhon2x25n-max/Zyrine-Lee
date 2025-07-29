#!/bin/bash

# ───[ 🧠 Vuln Git Automated ]───
# Made for Linux & Termux - by Michael Angelo

# Colors
R='\033[1;91m'; G='\033[1;92m'; Y='\033[1;93m'; B='\033[1;94m'; C='\033[1;96m'; W='\033[0m'

# Check dependencies
check_deps() {
  for cmd in git figlet; do
    if ! command -v $cmd >/dev/null 2>&1; then
      echo -e "${Y}[!] Installing missing: $cmd${W}"
      pkg install -y $cmd 2>/dev/null || sudo apt install -y $cmd
    fi
  done
}

# Banner
show_banner() {
  clear
  figlet -f slant "Vuln Git"
  echo -e "${C}─────[ Automated Git Manager ]─────${W}"
}

# Git config
setup_git() {
  echo -e "\n${Y}[!] Git not configured yet.${W}"
  read -p "👤 Enter your Git username: " user
  read -p "📧 Enter your Git email: " email
  git config --global user.name "$user"
  git config --global user.email "$email"
  echo -e "${G}[✔] Git config saved!${W}"
  sleep 1
}

# Get current Git info
git_info() {
  USER=$(git config user.name 2>/dev/null || echo "Not Set")
  EMAIL=$(git config user.email 2>/dev/null || echo "Not Set")
  REPO=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "None")
}

# Clone repo
clone_repo() {
  read -p "🔗 Enter GitHub repo URL: " url
  git clone "$url" && echo -e "${G}[✔] Repo cloned!${W}" || echo -e "${R}[✘] Failed to clone.${W}"
  sleep 1
}

# Add, commit, push
push_changes() {
  git status
  echo -e "${Y}⚠ Make sure you're inside a repo with changes.${W}"
  read -p "📝 Commit message: " msg
  git add . && git commit -m "$msg" && git push && echo -e "${G}[✔] Pushed!${W}" || echo -e "${R}[✘] Failed to push.${W}"
  sleep 1
}

# Pull changes
pull_changes() {
  git pull && echo -e "${G}[✔] Pulled latest changes.${W}" || echo -e "${R}[✘] Pull failed.${W}"
  sleep 1
}

# Rename repo folder
rename_repo() {
  read -p "📁 Current repo folder: " current
  read -p "✏️  New name: " new
  mv "$current" "$new" && echo -e "${G}[✔] Renamed to '$new'${W}" || echo -e "${R}[✘] Rename failed.${W}"
  sleep 1
}

# Delete specific file
delete_files() {
  read -p "🗑 Enter file(s) to delete (space-separated): " files
  for f in $files; do
    if [[ -f "$f" ]]; then
      rm -i "$f"
    else
      echo -e "${R}[!] $f not found.${W}"
    fi
  done
  sleep 1
}

# Delete entire repo folder
delete_repo() {
  read -p "⚠️  Enter folder name to delete: " folder
  if [[ -d "$folder" ]]; then
    read -p "⚠️  Are you sure? This deletes the whole repo '$folder' [y/N]: " confirm
    [[ $confirm == [yY] ]] && rm -rf "$folder" && echo -e "${G}[✔] Deleted.${W}" || echo -e "${Y}[!] Canceled.${W}"
  else
    echo -e "${R}[!] Folder not found.${W}"
  fi
  sleep 1
}

# Git status
show_status() {
  git status || echo -e "${R}[!] Not a Git repo.${W}"
  sleep 2
}

# Main menu
main_menu() {
  while true; do
    git_info
    show_banner
    echo -e "${B}📁 Repo:${W} $REPO   ${B}👤 Git User:${W} $USER <$EMAIL>"
    echo -e "\n${C}Choose an option:${W}"
    echo -e "${Y}[1]${W} Setup Git (username/email)"
    echo -e "${Y}[2]${W} Clone a GitHub Repo"
    echo -e "${Y}[3]${W} Add + Commit + Push Changes"
    echo -e "${Y}[4]${W} Pull Latest Changes"
    echo -e "${Y}[5]${W} Rename Local Repo Folder"
    echo -e "${Y}[6]${W} Delete Specific File(s) in Repo"
    echo -e "${Y}[7]${W} Delete Entire Repo Folder"
    echo -e "${Y}[8]${W} Show Git Status"
    echo -e "${Y}[9]${W} Exit"

    read -p $'\n🎯 Enter choice: ' opt
    case $opt in
      1) setup_git ;;
      2) clone_repo ;;
      3) push_changes ;;
      4) pull_changes ;;
      5) rename_repo ;;
      6) delete_files ;;
      7) delete_repo ;;
      8) show_status ;;
      9) echo -e "${G}Goodbye!${W}"; exit ;;
      *) echo -e "${R}[!] Invalid option.${W}"; sleep 1 ;;
    esac
  done
}

# ───[ START ]───
check_deps
main_menu
