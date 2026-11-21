# Search a whole project with grep -r, without node_modules, .git or binary junk
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs grep-r-exclude.tape
Output grep-r-exclude.mp4
Set Shell "bash"
Set FontFamily "Noto Sans Mono"
Set FontSize 38
Set LineHeight 1.25
Set Width 1920
Set Height 1080
Set Framerate 30
Set Padding 48
Set TypingSpeed 40ms
Set Theme "GitHub Dark"
Set WindowBar Colorful
Set CursorBlink false

Hide
Type `mkdir -p /lab/app && cd /lab/app && clear`
Enter
Type `mkdir -p src node_modules/left-pad .git dist bin logs`
Enter
Type `printf 'def login(user):\n    # TODO: rate limit\n    return check(user)\n' > src/auth.py`
Enter
Type `printf 'import auth\n# todo: remove debug flag\nDEBUG = True\nVERSION = "1.5"\n' > src/main.py`
Enter
Type `printf '// TODO: handle errors\nfetch("/api/catalog")\n' > src/client.js`
Enter
Type `printf '// TODO upstream bug\nmodule.exports = 1\n' > node_modules/left-pad/index.js`
Enter
Type `printf '[core]\n\t# TODO nothing\n' > .git/config`
Enter
Type `printf 'function a(){/*TODO*/return 1}' > dist/app.min.js`
Enter
Type `printf '\000\001ELF TODO\000' > bin/tool`
Enter
Type `printf '2026 login ok\n2026 user log out\nversion 105 started\n' > logs/app.log`
Enter
Type `clear`
Enter
Show

# --- The noisy first search
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The noisy first search`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 12461ms
Sleep 300ms
Type `grep -r "TODO" .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1606ms
Sleep 13479ms

# --- Skip folders with --exclude-dir
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Skip folders with --exclude-dir`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `grep -rn "TODO" --exclude-dir=node_modules --exclude-dir=.git .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6967ms
Sleep 10124ms

# --- Ignore binary files with -I
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Ignore binary files with -I`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 8743ms
Sleep 300ms
Type `grep -rnI "TODO" --exclude-dir={node_modules,.git,dist} .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6466ms
Sleep 5415ms
Sleep 8999ms

# --- Case, file types and file names
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Case, file types and file names`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `grep -rniI "todo" --exclude-dir={node_modules,.git,dist} .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1605ms
Sleep 6823ms
Sleep 300ms
Type `grep -rl "TODO" --include="*.py" .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9221ms
Sleep 6353ms

# --- Whole words with -w
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Whole words with -w`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `grep -rn "log" logs src`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1896ms
Sleep 7143ms
Sleep 300ms
Type `grep -rnw "log" logs src`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 3885ms

# --- Dots are wildcards: use -F
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Dots are wildcards: use -F`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `grep -rn "1.5" src logs`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 7740ms
Sleep 300ms
Type `grep -rnF "1.5" src logs`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6741ms

# --- Several patterns and some context
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Several patterns and some context`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `grep -rnIE "TODO|FIXME|DEBUG" --exclude-dir={node_modules,.git,dist} .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3264ms
Sleep 300ms
Type `grep -n -A 1 "TODO" src/auth.py`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8872ms
