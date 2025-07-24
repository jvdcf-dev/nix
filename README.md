# Nix dotfiles

Configuration files of @jvdcf's development environment

![PrintScreen example of the desktop environment](https://github.com/user-attachments/assets/77eeffa9-edc8-4226-8b74-6d2b695b0168)

## Installation

> [!WARNING]
> These dotfiles were only tested on my NixOS system and are provided **as is**; they may introduce breaking changes to your system. Backup and read the files before proceeding.
> The file `laptop/hardware-configuration.nix` is specific to my [ASUS Zenbook UX3405M](https://www.asus.com/us/laptops/for-home/zenbook/asus-zenbook-14-ux3405/techspec/) laptop!

- Install a fresh instance of [NixOS](https://nixos.org/download/);
- Clone the repository:
  ```sh
  mkdir nix
  cd nix
  git clone https://github.com/jvdcf-dev/nix.git
  ```
- Generate your `hardware-configuration.nix` and copy it to the `laptop/` folder:
  ```sh
  sudo nixos-generate-config
  rm ~/nix/laptop/hardware-configuration.nix
  cp /etc/nixos/hardware-configuration.nix ~/nix/laptop/hardware-configuration.nix
  ```
- Build the configuration:
  ```sh
  sudo nixos-rebuild switch --flake .#SillyBilly --extra-experimental-features nix-command flakes
  ```

## Applications

- 💻 **KDE** Desktop Environment
- 🐱 **Ghostty** Terminal
- 🐚 **Zsh** Shell (with zoxide, fastfetch and ohmyposh)
- 📝 **Zed** Editor

## Credits and special thanks

- **The Catppuccin Team**: [Hyprlock](https://github.com/catppuccin/hyprlock), [Kitty](https://github.com/catppuccin/kitty), [Swaync](https://github.com/catppuccin/swaync), [Waybar](https://github.com/catppuccin/waybar), [Fuzzel](https://github.com/catppuccin/fuzzel)
- **Dreams of Autonomy**: [zshrc](https://www.youtube.com/watch?v=ud7YxC33Z3w), [Oh My Posh](https://www.youtube.com/watch?v=9U8LCjuQzdc)
- [NvChad Team](https://nvchad.com/)
- [ErikReider's swaync config](https://github.com/ErikReider/Linux/blob/master/dotfiles/swayConfig/swaync/config.json)
- [Quantumfate's wofi theme](https://github.com/quantumfate/wofi)
- [Background image](home-modules/background.jpg) by [WallpaperCave](https://wallpapercave.com/w/wp6899679)

---

Feel free to fork, suggest changes, create issues and pull requests!
I hope these dotfiles help you just like other developers helped me 👋
