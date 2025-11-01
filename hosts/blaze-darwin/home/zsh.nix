{ ... }:
{
  programs.zsh =
    let
      homebrew = "/opt/homebrew";
    in
    {
      completionInit = ''
        fpath+=(${homebrew}/share/zsh/site-functions)
      '';
      envExtra = ''
        export PATH="/usr/local/bin:$PATH"

        eval "$(${homebrew}/bin/brew shellenv)"
      '';
    };
}
