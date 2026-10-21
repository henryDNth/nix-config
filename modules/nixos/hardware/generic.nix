{
  flake.modules.nixos.generic-hw =
    {
      config,
      modulesPath,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
          systemd-boot.configurationLimit = lib.mkDefault 5;
          systemd-boot.consoleMode = "max";
          systemd-boot.memtest86.enable = true;
          timeout = lib.mkDefault 10;
        };

        consoleLogLevel = lib.mkDefault 3;

        kernelParams = [
          "mem_sleep_default=s2idle"
          "quiet"
          "splash"
        ];

        plymouth.enable = true;

        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
          verbose = false;
          systemd.enable = true;
        };

        kernelModules = [ "amdgpu" ];
        kernelPackages = pkgs.linuxPackages_latest;
        extraModulePackages = [ ];
      };

      catppuccin.plymouth.enable = config.boot.plymouth.enable;

      # CPU
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.enableRedistributableFirmware = true;

      # GPU
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.amdgpu.initrd.enable = true;

      services.xserver.videoDrivers = [ "amdgpu" ];
    };
}
