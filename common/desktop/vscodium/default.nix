{ config, pkgs, ... }:

with pkgs;

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        saoudrizwan.claude-dev
        rooveterinaryinc.roo-cline
        continue.continue
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #{ # TODO - get this working. I need the correct hash basically.
        #  name = "spacemacs";
        #  publisher = "cometeer";
        #  version = "1.1.1";
        #  hash = "sha256-0bb76h796dy63k92rvi7fi3r9gqlawvy4fb7s5nkqv5lfrwxlqyp";
        #}
      ];
    })
  ];
}
