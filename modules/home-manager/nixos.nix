{
  config,
  inputs,
  ...
}:
{
  flake.modules.nixos.base =
    { params, lib, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        users.${params.user.name} = {
          imports = [
            (
              { osConfig, ... }:
              {
                home.stateVersion = osConfig.system.stateVersion;
              }
            )
            inputs.catppuccin.homeModules.catppuccin
            config.flake.modules.homeManager.base
          ]
          ++ lib.optionals (params.de.type == "cosmic") [ config.flake.modules.homeManager.cosmic ]
          ++ lib.optionals (params.gaming.enable) [ config.flake.modules.homeManager.gaming ]
          ++ lib.optionals (params.extras.enable) [ config.flake.modules.homeManager.extras ];
        };

        useGlobalPkgs = true;

        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs params;
          hasGlobalPkgs = true;
        };

        backupFileExtension = "backup";
      };
    };
}
