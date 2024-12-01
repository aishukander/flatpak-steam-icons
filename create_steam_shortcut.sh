# Loop through installed games and display options by `Name (ID)`
ENTRY_DIR=~/.var/app/com.valvesoftware.Steam/.local/share/applications
GAMES=()
for f in $ENTRY_DIR/*.desktop; do
	NAME=$(grep 'Name=' "$f" | cut -d\= -f2)
	EXEC=$(grep 'Exec=' "$f" | cut -d\= -f2)
	GAMES+=("$NAME (${EXEC##*/})")
done

echo "Choose an ID："
select GAME in "${GAMES[@]}"; do
    if [[ -n "$GAME" ]]; then
        ID=$(echo "$GAME" | grep -oP '\(([^)]+)\)' | tr -d '()')
        break
    else
        echo "Invalid selection please try again"
    fi
done

# Find and store the selected file in memory
for f in $ENTRY_DIR/*.desktop; do
	EXEC=$(grep 'Exec=' "$f" | cut -d\= -f2)
	F_ID=${EXEC##*/}
	if [ "$F_ID" = "$ID" ]; then
		F=$f
		break
	fi
done

# Find the highest resolution icon available
ICO_DIR=~/.var/app/com.valvesoftware.Steam/data/icons/hicolor
for dir in $(ls $ICO_DIR | sort -n -r); do
	DIR="$ICO_DIR/$dir/apps"
	if [ -f "$DIR/steam_icon_$ID.png" ]; then
		ICO="$DIR/steam_icon_$ID.png"
		break
	fi
done

# Construct new desktop entry from scratch using file data
F_NAME=$(grep 'Name=' "$F" | cut -d\= -f2)
F_EXEC=$(grep 'Exec=' "$F" | awk '{print $2}')
cd ~/Desktop
echo '[Desktop Entry]' > "$F_NAME.desktop"
echo "Name=$F_NAME" >> "$F_NAME.desktop"
echo "Exec=flatpak run com.valvesoftware.Steam $F_EXEC" >> "$F_NAME.desktop"
echo 'Terminal=false' >> "$F_NAME.desktop"
echo 'Type=Application' >> "$F_NAME.desktop"
echo 'Categories=Game;' >> "$F_NAME.desktop"
echo "Icon=$ICO" >> "$F_NAME.desktop"

# Set file as launchable
gio set "$F_NAME.desktop" metadata::trusted true
chmod a+x "$F_NAME.desktop"

# Optional pause to debug
if [ "$1" = "debug" ]; then
	echo "Finished"
	read DEBUG
fi

