{
  description = "test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    test.url = "github:nixos/nix/69b919887550483925b5a30388c13a63dabcca1a";
    test2.url = "github:nixos/patchelf/55c0b4f909815aa8d2bd93f535c34f9f60813c0e";
  };

  outputs =
    { nixpkgs
    , self
    , ...
    }@inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);

      pkgsFor = pkgs: system:
        import pkgs { inherit system; };

      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      forAllSystems = f: genAttrs allSystems
        (system: f {
          inherit system;
          pkgs = pkgsFor nixpkgs system;
        });
    in
    {
      pkgs = forAllSystems ({ pkgs, ... }: pkgs);
    };
}
