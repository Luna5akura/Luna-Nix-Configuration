{ config, pkgs, ... }:
{
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "lock";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    powerManagement.enable = true;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  environment.etc."nbfc/nbfc.json".text = ''
    {
      "SelectedConfigId": "HP Victus 16-e0xxx"
    }
  '';
}
