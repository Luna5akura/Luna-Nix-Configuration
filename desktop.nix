{ pkgs, config, ... }: 
let 
  # 定义键盘设备路径
  kboard_device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
in
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      options = ""; 
    };
 };

  environment.sessionVariables = {
    PLASMA_USE_QT_SCALING = "1";
  };

  # 确保 uinput 权限
  boot.kernelModules = [ "uinput" ];

  services.kanata = {
    enable = true;
    keyboards = {
      "laptop-keyboard" = {
        devices = [ kboard_device ];
        extraDefCfg = "process-unmapped-keys yes";
        
        config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet menu rctl
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

            spc_fn (tap-hold-release 200 200 spc (layer-toggle navigation))
            
            ;; 符号别名
            exlm S-1  
            at   S-2  
            hash S-3  
            curr S-4  
            prct S-5  
            circ S-6  
            ampr S-7  
            ast  S-8  
            lpar S-9  
            rpar S-0  
            lcbr S-[    
            rcbr S-]    
            plus S-=    
            und  S-min  
            pipe S-\    
            tild S-grv  

            blk XX 

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
            ;; 鼠标模拟别名 (Mouse Simulation - 加速版)
            ;; ====================================
            ;; 语法: (movemouse-accel-direction min-int min-dist max-int max-dist duration)
            ;; 说明: 
            ;; 1. 开始时: 每 10ms 移动 1px (非常慢且精确)
            ;; 2. 结束时: 每 5ms 移动 8px (非常快)
            ;; 3. 过渡期: 800ms 内完成加速
            
            m_up (movemouse-accel-up    10 500 1 20 )
            m_dn (movemouse-accel-down  10 500 1 20 )
            m_lf (movemouse-accel-left  10 500 1 20 )
            m_rt (movemouse-accel-right 10 500 1 20 )
            
            m_lc mlft ;; 鼠标左键
            m_rc mrgt ;; 鼠标右键

            ;; ====================================
            ;; 滚轮模拟 (Scroll Wheel)
            ;; ====================================
            ;; (mwheel-direction distance interval)
            ;; 50 是滚动距离，120 是时间间隔
            scr_u (mwheel-up 50 120)
            scr_d (mwheel-down 50 120)
          )

          ;; ====================================
          ;; 1. Hard Mode (默认层)
          ;; ====================================
          (deflayer base
            grv  1     2     3     4     5     6     7     8     9     0     -     =     @blk
            @blk  q     w     e     r     t     y     u     i     o     p     [     ]     \
            @esc_num @met_a @alt_s @sft_d @ctl_f g     h     @ctl_j @sft_k @alt_l @met_; '     @blk
            tab z     x     c     v     b     n     m     ,     .     /     @blk
            @blk @blk  @blk           @spc_fn          @blk @blk menu  @blk
          )

          ;; ====================================
          ;; 2. Navigation 层 (按住 Space)
          ;; ====================================
          (deflayer navigation
            _     f1    f2    f3    f4    f5    f6    f7    f8    f9    f10   f11   @to_norm  del
            _     @exlm @at   @hash @curr @prct @circ @ampr @ast  @lpar @rpar @und  _         _
            _     [     ]     @lcbr @rcbr ret   left  down  up    right _     _     _
            _     @und  =     -     @plus bspc  \     @pipe grv   @tild _     _
            _     _     _                 _                 _     _     _     _
          )

          ;; ====================================
          ;; 3. Numbers & Mouse 层 (按住 CapsLock/Esc)
          ;; ====================================
          ;; 左手: WASD 鼠标移动
          ;;       Q: 滚轮上, E: 滚轮下
          ;;       Alt/Spc: 点击
          ;; 右手: 数字小键盘
          (deflayer numbers
            _    _      _     _      _    _    _    _    _    _    _    _    _    _
            _    @scr_u @m_up @scr_d _    _    _    7    8    9    -    _    _    _
            _    @m_lf  @m_dn @m_rt  _    _  @und   4    5    6   @plus _    _
            _    _      _     _      _    _    0    1    2    3    .    _
            _    _      @m_rc          @m_lc          _    _    _    _
          )

          ;; ====================================
          ;; 4. Normal Mode (普通/游戏模式)
          ;; ====================================
          (deflayer normal
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            esc  a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    @my_und
            lctl lmet lalt           spc            @my_bs rmet menu  @to_base
          )
        '';
      };
    };
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.settings.X11 = {
      KeyboardLayout = "us";
      KeyboardOptions = "";
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
      qt6Packages.fcitx5-chinese-addons
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      wqy_microhei
      nerd-fonts.fira-code 
      sarasa-gothic
      jetbrains-mono
      ipafont 
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
  
  environment.etc."nbfc/nbfc.json".text = ''
    {
      "SelectedConfigId": "HP Victus 16-e0xxx" 
    }
  '';
}
