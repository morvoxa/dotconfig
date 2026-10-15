if status is-interactive
  #for void
    abbr -a xii "sudo xbps-install -S"
    abbr -a xse "sudo xbps-query -Rs"
    abbr -a xrm "sudo xbps-remove -R"
    abbr -a xoo "sudo xbps-remove -OOo"
    abbr -a cmt "$HOME/dotconfig/src/commit"
end

set -gx PNPM_BIN "$HOME/.local/share/pnpm/bin"
set -gx CARGO_BIN "$HOME/.cargo/bin"
set -gx LOCAL_BIN "$HOME/.local/bin"
set -gx PATH "$CARGO_BIN" "$PNPM_BIN" "$LOCAL_BIN" $PATH
