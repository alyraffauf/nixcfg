FILENAME="$XDG_PICTURES_DIR"/screenshots/$(date +'%Y-%m-%d-%H:%M:%S_grim.png')
MAKO_MODE=$(makoctl mode)

mkdir -p "$XDG_PICTURES_DIR"/screenshots

if echo "$MAKO_MODE" | grep -q "do-not-disturb"; then
  DND=true
else
  DND=false
  makoctl mode -t do-not-disturb
fi

grim -g "$(slurp -o)" "$FILENAME"

if [ "$DND" = false ]; then
  makoctl mode -t do-not-disturb
fi

if [ -e "$FILENAME" ]; then
  wl-copy -t image/png <"$FILENAME"
  notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"
fi
