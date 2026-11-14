{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.safesign;
in
{
  options.programs.safesign = {
    enable = lib.mkEnableOption "SafeSign Identity Client (PKCS#11 middleware for USB tokens)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      defaultText = lib.literalExpression "pkgs.callPackage ./package.nix { }";
      description = "SafeSign package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;

    environment.systemPackages = [ cfg.package ];

    # Register with p11-kit so that p11-kit-aware apps find the module
    environment.etc."pkcs11/modules/safesign.module".text = ''
      module: ${cfg.package}/lib/libaetpkss.so
    '';
  };
}
