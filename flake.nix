{
  description = "Browserstack Local, wrapped in a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    with nixpkgs.legacyPackages.x86_64-linux;
    let
      mkBrowserStackLocal =
        { url, hash }:
        stdenvNoCC.mkDerivation {
          name = "BrowserStackLocal";

          src = fetchzip {
            inherit url hash;
            name = "BrowserStackLocal-source";
          };

          buildInputs = [
            gcc-unwrapped
          ];

          nativeBuildInputs = [
            autoPatchelfHook
          ];

          sourceRoot = ".";

          installPhase = ''
            runHook preInstall
            install -m755 -D $src/BrowserStackLocal $out/bin/BrowserStackLocal
            runHook postInstall
          '';

          meta = {
            mainProgram = "BrowserStackLocal";
            homepage = "https://www.browserstack.com/";
            description = "BrowserStack Local testing app";
            downloadPage = "https://www.browserstack.com/docs/live/local-testing/set-up-local-testing#Linux";
            platforms = [ "x86_64-linux" ];
          };
        };
    in
    {
      packages.x86_64-linux = {
        BrowserStackLocal = nixpkgs.lib.makeOverridable mkBrowserStackLocal {
          url = "https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip";
          hash = "sha256-eP7xQak1W/S9eQXeTU0vmdqSr4Y6Jqa2tL2qiGpmhQo=";
        };

        default = self.packages.x86_64-linux.BrowserStackLocal;
      };
    };
}
