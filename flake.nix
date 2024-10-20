{
  description = "Browserstack Local, warpped in a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      lib = {
        mkBrowserStackLocal =
          {
            pkgs,
            srcUrl ? "https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip",
            srcHash ? "sha256-EloQ1oOT2FeFLMLlGsKv1SJrrNmvy4YNuTKJMgnI0y4=",
          }:
          with pkgs;
          stdenv.mkDerivation (self: {
            # Both of these options should be overrideable.
            # Useful in case the hash changes and the flake has not been updated
            inherit srcUrl srcHash;

            name = "BrowserStackLocal";

            src = fetchurl {
              url = self.srcUrl;
              hash = self.srcHash;
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
          });
      };

      packages.x86_64-linux.BrowserStackLocal = self.lib.mkBrowserStackLocal {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };

      packages.x86_64-linux.default = self.packages.x86_64-linux.BrowserStackLocal;

    };
}
