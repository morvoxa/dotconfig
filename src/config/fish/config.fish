if status is-interactive
  #for Arch
    abbr -a si "sudo pacman -Sy"
    abbr -a ss "sudo pacman -Ss"
    abbr -a srm "sudo pacman -Rns"
    abbr -a soo "sudo pacman -Scc"
    abbr -a cmt "$HOME/dotconfig/src/commit"
end

set -gx PNPM_BIN "$HOME/.local/share/pnpm/bin"
set -gx CARGO_BIN "$HOME/.cargo/bin"
set -gx LOCAL_BIN "$HOME/.local/bin"
set -gx PATH "$CARGO_BIN" "$PNPM_BIN" "$LOCAL_BIN" $PATH
