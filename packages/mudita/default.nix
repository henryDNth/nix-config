{
  lib,
  appimageTools,
  fetchurl,
  pkgs,
}:
let
  version = "4.0.0";
  pname = "mudita";

  src = fetchurl {
    url = "https://github.com/mudita/mudita-center/releases/download/${version}/Mudita-Center.AppImage";
    hash = "sha256-7PDB9NugrEcOgzBAfrML+0u4l78/o6fmCYIU/Qvj088=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  # 3. Use standard bash commands to view and copy files from the extraction
  extraInstallCommands = ''
    # View files during the build if debugging (prints to build log)
    echo "--- Listing extracted files ---"
    ls -la ${appimageContents}
    ls -la ${appimageContents}/usr
    ls -la ${appimageContents}/resources
    ls -la ${appimageContents}/locales

    # Install the desktop file from the extracted files into the output ($out)
    install -m 444 -D ${appimageContents}/"Mudita Center".desktop -t $out/share/applications

    # Copy icons from the extracted SquashFS bundle
    cp -r ${appimageContents}/usr/share/* $out/share

    # Correct the executable link inside the desktop shortcut
    substituteInPlace $out/share/applications/"Mudita Center".desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    wrapProgram $out/bin/${pname} \
        --prefix PATH : /run/wrappers/bin
  '';

  meta = {
    description = "App to manage mudita phones.";
    homepage = "https://github.com/mudita/mudita-center";
    downloadPage = "https://github.com/mudita/mudita-center/releases";
    license = lib.licenses.gpl3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
