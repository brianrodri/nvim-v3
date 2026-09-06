{ pkgs, ... }:

{
  packages = [ pkgs.lua-language-server ];

  git-hooks = {
    enable = true;
    hooks = {
      luacheck.enable = true;
      stylua.enable = true;

      mdformat.enable = true;
      markdownlint.enable = true;

      nixfmt.enable = true;
      deadnix.enable = true;
      statix.enable = true;

      taplo.enable = true;
      check-toml.enable = true;

      action-validator.enable = true;
      actionlint.enable = true;
      yamlfmt.enable = true;
      yamllint.enable = true;
    };
  };
}
