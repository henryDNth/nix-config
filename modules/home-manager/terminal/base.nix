{
  flake.modules.homeManager.base =
    {
      pkgs,
      lib,
      ...
    }:
    let
      shellAliases = {
        clock = ''${pkgs.tty-clock}/bin/tty-clock -B -c -C 4 -f "%a, %d %b"'';
        dmesg = "${pkgs.util-linux}/bin/dmesg --human --color=always";
        egrep = "${pkgs.gnugrep}/bin/egrep --color=auto";
        fgrep = "${pkgs.gnugrep}/bin/fgrep --color=auto";
        grep = "${pkgs.gnugrep}/bin/grep --color=auto";
        ip = "${pkgs.iproute2}/bin/ip --color --brief";
        lsusb = "${pkgs.cyme}/bin/cyme --headings";
        rsync-copy = "${pkgs.rsync}/bin/rsync --archive --block-size=131072 --human-readable --info=progress2 --inplace --no-compress --partial --stats";
        rsync-mirror = "${pkgs.rsync}/bin/rsync --archive --block-size=131072 --delete --human-readable --info=progress2 --no-compress --inplace --partial --stats";
        speedtest = "${pkgs.speedtest-go}/bin/speedtest-go";
        wormhole = "${pkgs.wormhole-rs}/bin/wormhole-rs";
        weather = "${lib.getExe pkgs.girouette} --quiet";
      };
      fishShellFunctions = {
        ns = {
          body = ''
            set -l cmd "nix flake show '.?submodules=1#'"
                      echo "> $cmd"
                      eval "$cmd"'';
          description = "nix flake show shortcut - displays packages in a given flake.";
        };
        nfu.body = ''
          set -l cmd "nix flake update $argv"
          eval "$cmd"
        '';
        nb = {
          body = ''
            set -l derivation $argv[1]
            set -l args $argv[2..-1]
            set -l cmd "${lib.getExe pkgs.nix-output-monitor} build $args '.?submodules=1#$derivation'"
            echo "> $cmd"
            eval "$cmd"
          '';
          description = "nix build - usage nb <package name> <build args>";
        };
        nd = {
          body = ''
            set -l cmd "${lib.getExe pkgs.nix-output-monitor} develop '.?submodules=1#$argv'"
            echo "> $cmd"
            eval "$cmd"
          '';
          description = "nix build - usage nd <package name>";
        };
        nr = {
          body = ''
            set -l derivation $argv[1]
            set -l args $argv[2..-1]
            set -l cmd "nix run --print-build-logs '.?submodules=1#$derivation'"
            if string length --quiet -- "$args"
              set cmd "nix run --print-build-logs '.?submodules=1#$derivation' -- $args"
            end
            echo "> $cmd"
            eval "$cmd"
          '';
          description = "nix run - usage: nr <package-name> <run args>";
        };
      };
      shellExtra = ''
        # nix flake show shortcut - displays packages in a given flake.
        ns() {
          local cmd="nix flake show '.?submodules=1#'"
          echo "> $cmd"
          eval "$cmd"
        }

        nfu() {
          local cmd="nix flake update $@"
          eval "$cmd"
        }

        # nix build - usage nb <package name>
        nb() {
          arg_array=($@)
          derivation=''${arg_array[1]}
          args=''${arg_array[@]:1}
          local cmd="${lib.getExe pkgs.nix-output-monitor} build ''${args} '.?submodules=1#''${derivation}'"
          echo "> $cmd"
          eval "$cmd"
        }

        nd() {
          local cmd="${lib.getExe pkgs.nix-output-monitor} develop '.?submodules=1#$@'"
          echo "> $cmd"
          eval "$cmd"
        }

        # nix run - usage: nr <package-name> <args>
        nr() {
          arg_array=($@)
          derivation=''${arg_array[1]}
          args=''${arg_array[@]:1}
          if [[ -n ''${args} ]]; then
            local cmd="nix run --print-build-logs '.?submodules=1#''${derivation}' -- ''${args}"
          else
            local cmd="nix run --print-build-logs '.?submodules=1#''${derivation}'"
          fi
          echo "> $cmd"
          eval "$cmd"
        }
      '';
    in
    {
      home = {
        packages = with pkgs; [
          bc # terminal calculator
          cyme # Modern Unix `lsusb`
          dua # Modern Unix `du`
          duf # Modern Unix `df`
          dust # Modern Unix `du`
          file # Terminal file info
          girouette # Modern Unix weather
          gping # Modern Unix `ping`
          hexyl # Modern Unix `hexedit`
          magic-wormhole-rs # Terminal file transfer
          pciutils # Terminal PCI info
          procs # Modern Unix `ps`
          psmisc # Traditional `ps`
          rsync # Traditional `rsync`
          sd # Modern Unix `sed`
          speedtest-go # Terminal speedtest.net
          unzip # Terminal ZIP extractor
          wget # Terminal HTTP client
          wget2 # Terminal HTTP client
          tty-clock # Terminal clock
          usbutils # Terminal USB info
          wavemon # Terminal WiFi monitor
          nix-output-monitor # nix output monitor
        ];
      };

      programs = {
        bash = {
          shellAliases = shellAliases;
          initExtra = shellExtra;
        };
        fish = {
          shellAliases = shellAliases;
          functions = fishShellFunctions;
        };
        zsh = {
          shellAliases = shellAliases;
          initContent = shellExtra;
        };
      };
    };
}
