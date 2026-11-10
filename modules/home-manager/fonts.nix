{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home = {
        file.".config/fontconfig/fonts.conf".text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <match target="font">
              <edit name="antialias" mode="assign">
                <bool>true</bool>
              </edit>
              <edit name="hinting" mode="assign">
                <bool>true</bool>
              </edit>
              <edit name="hintstyle" mode="assign">
                <const>hintslight</const>
              </edit>
              <edit name="rgba" mode="assign">
                <const>rgb</const>
              </edit>
              <edit name="lcdfilter" mode="assign">
                <const>lcddefault</const>
              </edit>
            </match>
          </fontconfig>
        '';
        packages = with pkgs; [
          nerd-fonts.fira-code
          font-awesome
          noto-fonts-color-emoji
          noto-fonts-monochrome-emoji
          symbola
          work-sans
          corefonts
          fira-go
          fira-sans
          lato
          liberation_ttf
          nerd-fonts.space-mono
          nerd-fonts.symbols-only
          source-serif
          ubuntu-classic
          unscii
          cascadia-code
        ];
      };

      fonts = {
        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [
              "Source Serif"
              "Noto Color Emoji"
            ];
            sansSerif = [
              "Work Sans"
              "Noto Color Emoji"
            ];
            monospace = [
              "Cascadia Mono NF"
              "FiraCode Nerd Font Mono"
              "Font Awesome 6 Free"
              "Font Awesome 6 Brands"
              "Symbola"
              "Noto Emoji"
            ];
            emoji = [
              "Noto Color Emoji"
            ];
          };
        };
      };
    };
}
