if status is-interactive
  #for Arch
    abbr -a xi "sudo xbps-install -S"
    abbr -a xs "sudo xbps-query -Rs"
    abbr -a xrm "sudo xbps-remove -R"
    abbr -a xoo "sudo xbps-remove -OOo"
    abbr -a cmt "$HOME/dotconfig/src/commit"
end

set -gx JAVA_HOME "$HOME/Java/jdk-27.0.1.0.3" #https://download.java.net/java/GA/jdk27.0.1.0.3/b14170c9b2de463d9b89442c6db3e384/1/GPL/openjdk-27.0.1.0.3_linux-x64_bin.tar.gz
set -gx JAVA_PATH "$HOME/Java/jdk-27.0.1.0.3/bin"
set -gx PNPM_BIN "$HOME/.local/share/pnpm/bin"
set -gx CARGO_BIN "$HOME/.cargo/bin"
set -gx LOCAL_BIN "$HOME/.local/bin"
set -gx PATH "$CARGO_BIN" "$PNPM_BIN" "$LOCAL_BIN" "$JAVA_PATH" $PATH
