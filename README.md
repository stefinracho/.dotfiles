# .dotfiles

1. Install a browser, [Hyprland](https://wiki.hyprland.org/Getting-Started/Installation/), [Kitty](https://archlinux.org/packages/extra/x86_64/kitty/), and [paru](https://github.com/Morganamilo/paru)
```sh
sudo pacman -S --needed base-devel firefox git hyprland kitty && cd && git clone \
https://aur.archlinux.org/paru.git && cd paru && makepkg -si
```

2. Start Hyprland (from the tty)
```sh
start-hyprland
```

3. Install AUR packages
```sh
paru -S --needed electronmail-bin jellyfin-desktop-git pwvucontrol python-grip-git
```

4. Install everything else
```sh
sudo pacman -S --needed adobe-source-sans-fonts adobe-source-serif-fonts anki blueman \
bluez-utils brightnessctl cups discord docker docker-buildx docker-compose dunst fastfetch \
fd ghostty gimp gnome-keyring grim hplip hunspell hunspell-en_us hypridle hyprlock \
hyprpaper hyprpolkitagent jq ksnip libreoffice-fresh luarocks mpv neovim networkmanager \
network-manager-applet nextcloud-client noto-fonts noto-fonts-cjk noto-fonts-emoji npm \
nwg-look pandoc-cli pipewire pipewire-pulse python-weasyprint qalculate-qt qbittorrent \
qt5ct qt5-wayland qt6ct qt6-wayland ripgrep rsync slurp stow system-config-printer tmux \
tree-sitter-cli ttf-noto-nerd uwsm waybar wireplumber wl-clipboard wofi \
xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
```

5. Configure PAM for GNOME Keyring (for TTY login)
```sh
sudo sed -i \
-e '/^auth\s\+include\s\+system-local-login/a auth       optional     pam_gnome_keyring.so' \
-e '/^session\s\+include\s\+system-local-login/a session    optional     pam_gnome_keyring.so auto_start' \
-e '/^password\s\+include\s\+system-local-login/a password   optional     pam_gnome_keyring.so' \
/etc/pam.d/login
```

6. Enable user services
```sh
systemctl --user enable --now hypridle.service hyprpaper.service hyprpolkitagent.service \
waybar.service
```

7. Enable system services
```sh
systemctl enable --now bluetooth.service cups.service docker.socket NetworkManager.service
```

8. Stow everything
```sh
cd ~/.dotfiles/ && stow --adopt .
```

9. Restore `.dotfiles/` directory
```sh
cd ~/.dotfiles/ && git restore .
```

10. Reboot
```sh
reboot
```
