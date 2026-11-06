run_cmd() {
	eval "$@"
}
BASE_DIR=$(pwd)
echo -e " │   └── \e[34m[MOVING]\e[0m Keyboard Config"
run_cmd "cp -rf '$BASE_DIR/keyboards.xml' ~/.config/xfce4/xfconf/xfce-perchannel-xml"
echo -e " │   └── \e[34m[MOVING]\e[0m Keyboard Shortcut"
run_cmd "cp -rf '$BASE_DIR/xfce4-keyboard-shortcuts.xml' ~/.config/xfce4/xfconf/xfce-perchannel-xml"
