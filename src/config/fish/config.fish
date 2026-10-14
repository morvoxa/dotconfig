if status is-interactive
  #for void
    abbr -a xii "sudo xbps-install -S"
    abbr -a xse "sudo xbps-query -Rs"
    abbr -a xrm "sudo xbps-remove -R"
    abbr -a xoo "sudo xbps-remove -OOo"
    abbr -a cmt "$HOME/nixos-config/src/commit"
    direnv hook fish | source
end

set -gx PNPM_PATH "$HOME/.local/share/pnpm/bin"
set -gx CARGO_HOME "$HOME/.cargo/bin"
set -gx LOCAL_HOME "$HOME/.local/bin"
set -gx PATH "$CARGO_HOME" "$PNPM_PATH" "$LOCAL_HOME" $PATH
