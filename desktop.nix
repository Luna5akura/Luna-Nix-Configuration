{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    # displayManager.sessionCommands = "xmodmap ~/.Xmodmap";

    xkb = {
      # variant = "altr_to_backslash";
      options = "caps:swapescape";
      layout = "custom";
      extraLayouts.custom = {
        description = "Custom layout with Alt_R as backslash";
        languages = [ "eng" ];
        symbolsFile = pkgs.writeText "custom_symbols" ''
          partial modifier_keys
          xkb_symbols "custom" {
              include "us(basic)"
              replace key <RALT> { [ backslash, bar ] };
              key <RTSH> { [ underscore, underscore ] };
          };
        '';
      };  
    };
 };

  environment.etc."X11/xkb/symbols/custom" = {
    source = /etc/nixos/custom_symbols; 
  };

  environment.sessionVariables = {
    PLASMA_USE_QT_SCALING = "1";
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.settings.X11= {
      KeyboardLayout = "custom";
      KeyboardOptions = "caps:swapescape";
    };
    defaultSession = "plasmax11";
  };
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      fcitx5-rime
      fcitx5-anthy
      fcitx5-material-color
      fcitx5-chinese-addons
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      wqy_microhei
      nerd-fonts.fira-code 
      sarasa-gothic
      jetbrains-mono
      ipafont # Japanese fonts
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Jetbrains Mono" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
      };
    };
    enableDefaultPackages = true;
  };

}
