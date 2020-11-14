tell application "Spotify" 
  --activate
  set TheArtist to artist of current track
  set TheTitle to name of current track
end tell

set output to ("Now Playing: " & TheArtist & " - " & TheTitle)
copy output to stdout
