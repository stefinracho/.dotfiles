# .dotfiles

1. Install [paru](https://github.com/Morganamilo/paru) and [Kitty](https://archlinux.org/packages/extra/x86_64/kitty/)
```sh
sudo pacman -S --needed git base-devel kitty && git clone \
https://aur.archlinux.org/paru.git && cd paru && makepkg -si
```

2. Install [Hyprland](https://wiki.hyprland.org/Getting-Started/Installation/) and a browser
```sh
paru -S firefox hyprland-git
```

3. Start Hyprland (from the tty)
```sh
Hyprland
```

4. Install [uwsm](https://aur.archlinux.org/packages/uwsm) and other useful AUR packages
```sh
paru -S anki hypridle-git hyprlock-git hyprpaper-git hyprpolkitagent-git pwvucontrol uwsm \
xdg-desktop-portal-gtk-git xdg-desktop-portal-hyprland-git
```

5. Install everything else
```sh
sudo pacman -S --needed adobe-source-sans-fonts adobe-source-serif-fonts blueman \
bluez-utils brightnessctl cups discord docker docker-buildx docker-compose dunst fastfetch \
fd ghostty gimp grim hplip hunspell hunspell-en_us jq ksnip libreoffice-fresh luarocks mpv \
neovim networkmanager network-manager-applet nextcloud-client noto-fonts noto-fonts-cjk \
noto-fonts-emoji npm nwg-look pandoc-cli pipewire pipewire-pulse python-weasyprint \
qalculate-qt qbittorrent qt5ct qt5-wayland qt6ct qt6-wayland ripgrep rsync slurp stow \
system-config-printer tmux ttf-noto-nerd waybar wireplumber wl-clipboard wofi
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
