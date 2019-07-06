self: super: {

  lazydocker = super.buildGoModule rec {
    name = "lazydocker-${version}";
    version = "v0.5";

    src = super.fetchFromGitHub {
      owner = "jesseduffield";
      repo = "lazydocker";
      rev = version;
      sha256 = "0f062xn58dbci22pg6y4ifcdfs8whzlv2jjprxxk2ygzixrrjwnc";
    };

    modSha256 = "1navp9rrnwb06may7vw102vfg07ai22mi0cnfycnmb63820106qz";

    meta = {
      description = "A simple terminal UI for both docker and docker-compose";
      homepage = https://github.com/jesseduffield/lazydocker;
      license = super.stdenv.lib.licenses.mit;
      platforms = with super.stdenv.lib.platforms; linux ++ darwin;
    };
  };

}
