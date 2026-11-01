if status is-interactive
  #for Arch
    abbr -a xi "sudo xbps-install -S"
    abbr -a xs "sudo xbps-query -Rs"
    abbr -a xrm "sudo xbps-remove -R"
    abbr -a xoo "sudo xbps-remove -OOo"
    abbr -a cmt "$HOME/dotconfig/src/commit"
end

#https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
set -gx JAVA_HOME "$HOME/Java/jdk-17.0.2"
set -gx JAVA_PATH "$HOME/Java/jdk-17.0.2/bin"
#https://github.com/JetBrains/kotlin/releases/download/v2.4.21/kotlin-compiler-2.4.21.zip
set -gx KOTLIN_PATH "$HOME/kotlinc/bin"
set -gx PNPM_BIN "$HOME/.local/share/pnpm/bin"
set -gx CARGO_BIN "$HOME/.cargo/bin"
set -gx LOCAL_BIN "$HOME/.local/bin"
set -gx PATH "$CARGO_BIN" "$PNPM_BIN" "$LOCAL_BIN" "$JAVA_PATH" "$KOTLIN_PATH" $PATH
