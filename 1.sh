#!/bin/bash

# ───[ 🔧 GIT TOOLKIT - ALL IN ONE FOR TERMUX 🔧 ]───
# Made for Termux users to manage GitHub repos easily

G='\033[1;92m'; Y='\033[1;93m'; R='\033[1;91m'; C='\033[1;96m'; W='\033[0m'

clear

# ── Auto Git Setup ──
auto_git_setup() {
    if ! command -v git &>/dev/null; then
        echo -e "${Y}Git not found. Installing...${W}"
        pkg install git -y
    fi

    git config --global user.name >/dev/null 2>&1 || {
        echo -e "${Y}Git global config not found. Let's set it up.${W}"
        read -p "Enter your GitHub username: " username
        git config --global user.name "$username"
        read -p "Enter your GitHub email: " email
        git config --global user.email "$email"
    }

    echo -e "${G}✔ Git is installed and configured.${W}"
    sleep 1
}

# ── Git Init ──
git_init() {
    git init
    echo -e "${G}✔ Repository initialized.${W}"
}

# ── Set Remote ──
git_set_remote() {
    read -p "Enter GitHub repo URL: " url
    git remote add origin "$url"
    echo -e "${G}✔ Remote set to $url${W}"
}

# ── Push Code ──
git_push() {
    read -p "Commit message: " msg
    git add .
    git commit -m "$msg"
    git branch -M main
    git push -u origin main
    echo -e "${G}✔ Code pushed to main branch.${W}"
}

# ── Rename Branch ──
git_rename_branch() {
    read -p "New branch name: " new_branch
    git branch -m "$new_branch"
    echo -e "${G}✔ Branch renamed to $new_branch${W}"
}

# ── Delete Local Repo ──
delete_local() {
    read -p "This will delete all .git data. Continue? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        rm -rf .git
        echo -e "${R}✘ Local Git repo deleted.${W}"
    else
        echo -e "${Y}Cancelled.${W}"
    fi
}

# ── View Git Config ──
view_config() {
    git config --list
}

# ── Menu ──
while true; do
    clear
    echo -e "${C}"
    echo "┌────────────────────────────────────┐"
    echo "│    🔧 GitHub Toolkit Menu (Termux) │"
    echo "└────────────────────────────────────┘"
    echo -e "${Y}Choose an option:${W}"
    echo -e "${G}[1]${W} Auto Setup Git (Install & Configure)"
    echo -e "${G}[2]${W} Init Git Repo"
    echo -e "${G}[3]${W} Set Remote Repo (origin)"
    echo -e "${G}[4]${W} Push Code to GitHub"
    echo -e "${G}[5]${W} Rename Current Branch"
    echo -e "${G}[6]${W} Delete Local Git Repo"
    echo -e "${G}[7]${W} View Git Config"
    echo -e "${G}[0]${W} Exit"
    echo
    read -p "📦 Enter your choice: " choice

    case $choice in
        1) auto_git_setup ;;
        2) git_init ;;
        3) git_set_remote ;;
        4) git_push ;;
        5) git_rename_branch ;;
        6) delete_local ;;
        7) view_config; read -p "Press enter to continue..." ;;
        0) echo -e "${C}Goodbye!${W}"; break ;;
        *) echo -e "${R}Invalid option.${W}"; sleep 1 ;;
    esac
done
