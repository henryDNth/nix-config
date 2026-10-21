{
  inputs,
  ...
}:
{
  flake.modules.nixos.dell-precision-5690-hw =
    {
      config,
      modulesPath,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.dell-precision-5490
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        extraModprobeConfig = ''
          options bbswitch load_state=-1 unload_state=1 nvidia-drm
        '';

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
          "quiet"
          "splash"
        ];

        plymouth.enable = true;

        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "thunderbolt"
            "nvme"
            "usb_storage"
            "sd_mod"
          ];
          verbose = false;
          systemd.enable = true;
        };

        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxPackages;
      };

      catppuccin.plymouth.enable = config.boot.plymouth.enable;

      # Bluetooth
      hardware.bluetooth = {
        enable = true;
        settings.General.Enable = "Source,Sink,Media,Socket";
      };

      hardware.nvidia = {
        prime = {
          nvidiaBusId = "PCI:1:0:0";
          intelBusId = "PCI:0:2:0";
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };

        dynamicBoost.enable = true;

        # this causes graphical glitches occasionally on sleep for my machine
        nvidiaPersistenced = false;

        # TODO(emily): might also have to turn this off for hybrid GPU setup
        modesetting.enable = true;

        # Power management can cause issues with sleep. It's marked as experimental anyways
        # so lets just keep it off for now
        powerManagement.enable = false;
        powerManagement.finegrained = false;

        open = false;
        nvidiaSettings = true;
        package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.production;
      };

      # CPU
      hardware.enableAllFirmware = true;
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.enableRedistributableFirmware = true;

      hardware.wirelessRegulatoryDatabase = true;

      # GPU
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      services.xserver.videoDrivers = [
        "intel"
        "nvidia"
      ];
    };
}
