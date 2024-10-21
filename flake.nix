{
  description = "Browserstack Local, warpped in a flake";

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

          src = fetchurl {
            inherit url hash;
          };

          buildInputs = [
            gcc-unwrapped
          ];

          nativeBuildInputs = [
            autoPatchelfHook
            unzip
          ];

          sourceRoot = ".";

          unpackPhase = ''
            unzip $src
          '';

          installPhase = ''
            runHook preInstall
            install -m755 -D BrowserStackLocal $out/bin/BrowserStackLocal
            runHook postInstall
          '';

          meta = {
            homepage = "https://www.browserstack.com/";
            description = "BrowserStack Local testing app";
            downloadPage = "https://www.browserstack.com/docs/live/local-testing/set-up-local-testing#Linux";
            # license = lib.licenses.unfreeRedistributable;
            platforms = [ "x86_64-linux" ];
          };
        };
    in
    {
      packages.x86_64-linux = {
        BrowserStackLocal = nixpkgs.lib.makeOverridable mkBrowserStackLocal {
          url = "https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip";
          hash = "sha256-EloQ1oOT2FeFLMLlGsKv1SJrrNmvy4YNuTKJMgnI0y4=";
        };

        default = self.packages.x86_64-linux.BrowserStackLocal;
      };
    };
}
