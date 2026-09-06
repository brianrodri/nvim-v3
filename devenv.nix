{ pkgs, ... }:

{
  packages = [ pkgs.lua-language-server ];

  git-hooks = {
    enable = true;
    hooks = {
      luacheck.enable = true;
      stylua.enable = true;

      nixfmt.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };
}
