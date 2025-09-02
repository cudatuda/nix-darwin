{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.wallpaper;
in
{
  meta.maintainers = [ (lib.maintainers.cudatuda or "cudatuda") ];

  options.desktop.wallpaper = {
    enable = lib.mkEnableOption {
      description = "wallpaper management";
    };
    image = lib.mkOption {
      type = with lib.types; nullOr (coercedTo package toString path);
      default = null;
      example = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/f07707cecfd89bc1459d5dad76a3a4c5315efba1/wallpapers/nix-wallpaper-nineish-dark-gray.png";
        hash = "sha256-nhIUtCy/Hb8UbuxXeL3l3FMausjQrnjTVi1B3GkL9B8=";
      };
      description = "image to set as desktop wallpaper";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.image != null;
        message = "`config.desktop.wallpaper.image` must be specified.";
      }
    ];

    system = {
      activationScripts.wallpaper.text = ''
        /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "${cfg.image}"'
      '';
    };
  };
}
