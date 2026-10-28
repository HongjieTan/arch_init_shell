#!/usr/bin/env bash

TASKS=()
TASKS+=('安装官方库软件::sudo pacman -Sy --noconfirm amd-ucode git git-zsh-completion base-devel adw-gtk-theme glib2 btrfs-assistant chromium fastfetch fcitx5-rime ghostty ghostty-terminfo gamemode kmscon kmscon-terminfo libreoffice-fresh-zh-cn nano nano-syntax-highlighting nautilus pacman-contrib papirus-icon-theme starship steam ttf-firacode-nerd ttf-sarasa-gothic xorg-xrdb zed sbctl zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting power-profiles-daemon snap-pac bluez wireless-regdb openrgb i2c-tools noctalia libva-nvidia-driver pipewire-libcamera rtkit xdg-desktop-portal-hyprland ufw less oo7 seahorse hyprland')
TASKS+=('安装 aur库软件::git clone https://aur.archlinux.org/paru.git; cd paru; makepkg -si; sudo pacman -Rns paru-debug; paru -S limine-mkinitcpio-hook limine-snapper-sync mangojuice protonplus wechat-bin noctalia-greeter pwvucontrol strata-bin')
TASKS+=('移除多余软件::sudo pacman -Rns $(pacman -Qtdq)')
TASKS+=('软连接配置和文件::sudo mkdir -p /root/.config; sudo ln -s ~/.config/gtk-3.0 /root/.config/gtk-3.0; sudo ln -s ~/.config/gtk-4.0 /root/.config/gtk-4.0; sudo ln -s ~/.nanorc /root/.nanorc; sudo ln -s ~/.config/starship.toml /root/.config/starship.toml; echo '\''eval "$(starship init zsh)"'\'' | sudo tee /root/.zshrc; sudo rm -rf /usr/share/icons/default; sudo ln -s ~/.local/share/icons/default /usr/share/icons/default; sudo mv ~/.local/share/icons/Bibata-* /usr/share/icons/; chsh -s $(which zsh)')
TASKS+=('配置gtk主题::gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3; gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3; gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'')
TASKS+=('禁用无关服务::sudo systemctl disable --now systemd-oomd; sudo systemctl mask systemd-oomd; sudo systemctl disable --now systemd-networkd; sudo systemctl mask systemd-networkd; sudo systemctl disable --now systemd-userdbd; sudo systemctl mask systemd-userdbd; sudo systemctl disable --now systemd-homed; sudo systemctl mask systemd-homed')

ask_and_run() {
    local desc="$1"
    local cmd="$2"
    local ans

    while true; do
        read -r -p "是否执行【${desc}】? [y/N]: " ans
        case "${ans:-n}" in
            y|Y|yes|YES|Yes)
                echo "==> 开始执行: ${cmd}"
                if eval "${cmd}"; then
                    echo "==> 执行成功: ${desc}"
                else
                    echo "!!! 执行失败(退出码 $?): ${desc}" >&2
                fi
                return 0
                ;;
            n|N|no|NO|No)
                echo "==> 已跳过: ${desc}"
                return 1
                ;;
            *)
                echo "请输入 y 或 n"
                ;;
        esac
    done
}

if sudo -v; then
    echo "sudo凭据已获取。"
else
    echo "认证失败，退出。" >&2
    exit 1
fi
total=${#TASKS[@]}
for ((i = 0; i < total; i++)); do
    task="${TASKS[i]}"
    desc="${task%%::*}"
    cmd="${task#*::}"

    echo
    echo "----- 第 $((i + 1))/${total} 步 -----"
    ask_and_run "$desc" "$cmd"
done

echo
echo "全部步骤处理完毕。"
