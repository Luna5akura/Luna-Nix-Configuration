{ pkgs, ... }:
let
  keyboardDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
in
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    xkb.layout = "us";
  };

  services.displayManager = {
    defaultSession = "plasmax11";

    sddm = {
      enable = true;
      wayland.enable = false;
      settings.X11.KeyboardLayout = "us";
    };
  };

  services.desktopManager.plasma6.enable = true;

  environment.sessionVariables = {
    PLASMA_USE_QT_SCALING = "1";
  };

  boot.kernelModules = [ "uinput" ];

  services.kanata = {
    enable = true;
    keyboards.laptop-keyboard = {
      devices = [ keyboardDevice ];
      extraDefCfg = ''
        process-unmapped-keys yes
        concurrent-tap-hold yes
      '';

      config = ''
        (defsrc
          grv 1 2 3 4 5 6 7 8 9 0 - = bspc
          tab q w e r t y u i o p [ ] \
          caps a s d f g h j k l ; ' ret
          lsft z x c v b n m , . / rsft
          lctl lmet lalt spc ralt rmet menu rctl
        )

        (defvar
          tap-timeout 200
          hold-timeout 200
        )

        (defalias
          ;; ====================================
          ;; 模式切换开关
          ;; ====================================
          to_norm (layer-switch normal)
          to_base (layer-switch base)

          ;; ====================================
          ;; Hard Mode (Base Layer) 别名
          ;; ====================================
          met_a (tap-hold-release 200 200 a lmet)
          alt_s (tap-hold-release 200 200 s lalt)
          sft_d (tap-hold-release 200 200 d lsft)
          ctl_f (tap-hold-release 200 200 f lctl)
          ctl_j (tap-hold-release 200 200 j rctl)
          sft_k (tap-hold-release 200 200 k rsft)
          alt_l (tap-hold-release 200 200 l ralt)
          met_; (tap-hold-release 200 200 ; rmet)

          ;; 空格：短按 = 空格，长按 = Navigation 层
          spc_fn (tap-hold-press $tap-timeout $hold-timeout spc (layer-while-held navigation))

          ;; 物理左 Shift：短按 = Tab，长按 = 符号层
          lsft_tab_sym (tap-hold-press $tap-timeout $hold-timeout tab (layer-while-held symbols))

          ;; ====================================
          ;; 符号别名（编程常用）
          ;; ====================================
          exlm S-1
          at S-2
          hash S-3
          curr S-4
          prct S-5
          circ S-6
          ampr S-7
          ast S-8
          lpar S-9
          rpar S-0
          lcbr S-[
          rcbr S-]
          plus S-=
          und S-min
          pipe S-\
          tild S-grv
          blk XX

          ;; 新增：解决 symbols 层报错的关键别名
          scln ;
          colon S-scln
          quot '

          ;; ====================================
          ;; Normal Mode (Old Custom) 别名
          ;; ====================================
          my_bs \
          my_und S-min

          ;; ====================================
          ;; Numbers Layer 触发器
          ;; ====================================
          esc_num (tap-hold-release 200 200 esc (layer-toggle numbers))

          ;; ====================================
          ;; 鼠标模拟别名
          ;; ====================================
          m_up (movemouse-accel-up 10 500 1 40 )
          m_dn (movemouse-accel-down 10 500 1 40 )
          m_lf (movemouse-accel-left 10 500 1 40 )
          m_rt (movemouse-accel-right 10 500 1 40 )
          m_lc mlft
          m_rc mrgt

          ;; ====================================
          ;; 滚轮模拟
          ;; ====================================
          scr_u (mwheel-up 50 120)
          scr_d (mwheel-down 50 120)
        )

        ;; ====================================
        ;; 1. Hard Mode (默认层)
        ;; ====================================
        (deflayer base
          grv 1 2 3 4 5 6 7 8 9 0 - = @blk
          @blk q w e r t y u i o p [ ] \
          @esc_num @met_a @alt_s @sft_d @ctl_f g h @ctl_j @sft_k @alt_l @met_; ' @blk
          @lsft_tab_sym z x c v b n m , . / @blk
          @blk @blk @blk @spc_fn @blk @blk menu @blk
        )

        ;; ====================================
        ;; 2. Navigation 层 (按住 Space)
        ;; ====================================
        (deflayer navigation
          _ f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 @to_norm del
          _ @exlm @at @hash @curr @prct @circ @ampr @ast @lpar @rpar @und _ _
          _ @lcbr @rcbr [ ] ret left down up right _ _ _
          _ @und = - @plus bspc \ @pipe grv @tild _ _
          _ _ _ _ _ _ _ _
        )

        ;; ====================================
        ;; 3. Numbers & Mouse 层 (按住 CapsLock/Esc)
        ;; ====================================
        (deflayer numbers
          _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _ @scr_u @m_up @scr_d _ _ bspc 7 8 9 - _ _ _
          _ @m_lf @m_dn @m_rt _ ret @und 4 5 6 @plus _ _
          _ _ _ _ _ _ 0 1 2 3 . _
          _ _ @m_rc @m_lc _ _ _ _
        )

        ;; ====================================
        ;; 4. Normal Mode (普通/游戏模式)
        ;; ====================================
        (deflayer normal
          grv 1 2 3 4 5 6 7 8 9 0 - = bspc
          tab q w e r t y u i o p [ ] \
          esc a s d f g h j k l ; ' ret
          lsft z x c v b n m , . / @my_und
          lctl lmet lalt spc @my_bs rmet menu @to_base
        )

        ;; ====================================
        ;; 5. Symbols 层（物理左 Shift 长按触发）
        ;; ====================================
        ;; 常用编程符号置于强指区域，便于快速输入表达式
        (deflayer symbols
          _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _ @exlm @at @hash @curr @prct @circ @ampr @ast @lpar @rpar @und _ _
          _ @lcbr @rcbr [ ] ret @colon @scln @quot _ _ _ _
          _ @und = - @plus bspc _ _ _ _ _ _
          _ _ _ _ _ _ _ _
        )
      '';
    };
  };

  services.printing.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-anthy
      fcitx5-gtk
      fcitx5-material-color
      fcitx5-rime
      libsForQt5.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      ipafont
      jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      sarasa-gothic
      wqy_microhei
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Jetbrains Mono" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
      };
    };
  };
}
