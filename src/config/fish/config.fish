if status is-interactive
  #for Arch
    abbr -a xi "sudo xbps-install -S"
    abbr -a xs "sudo xbps-query -Rs"
    abbr -a xrm "sudo xbps-remove -R"
    abbr -a xoo "sudo xbps-remove -OOo"
    abbr -a vs "code -r ."
    abbr -a cmt "$HOME/dotconfig/src/commit"
end

# Download URL referensi:
# Java 17.0.2: https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
# Kotlin 2.4.21: https://github.com/JetBrains/kotlin/releases/download/v2.4.21/kotlin-compiler-2.4.21.zip

set -gx JAVA_HOME "$HOME/Java/jdk-17.0.2"
set -gx PATH "$HOME/.cargo/bin" \
            "$HOME/.local/share/pnpm/bin" \
            "$HOME/.local/bin" \
            "$HOME/Java/jdk-17.0.2/bin" \
            "$HOME/kotlinc/bin" \
            $PATH
