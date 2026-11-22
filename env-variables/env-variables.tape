# Environment variables explained: export, .env files, env, and why sudo drops them
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs env-variables.tape
Output env-variables.mp4
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
Type `mkdir -p /lab/env && cd /lab/env && clear`
Enter
Type `printf 'DB_HOST=db.local\nDB_PORT=5432\n' > app.env`
Enter
Type `clear`
Enter
Show

# --- Shell variable or environment variable?
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Shell variable or environment variable?`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `GREETING=hello; bash -c 'echo "child sees: [$GREETING]"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2096ms
Sleep 300ms
Type `GREETING=hello; export GREETING; bash -c 'echo "child sees: [$GREETING]"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7143ms
Sleep 8978ms

# --- Just for one command
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Just for one command`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `GREETING=hi bash -c 'echo "child sees: [$GREETING]"'; echo "shell has: [$GREETING]"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4167ms
Sleep 300ms
Type `GREETING=hi echo "[$GREETING]"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2554ms
Sleep 11985ms

# --- Inspect the environment with env
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Inspect the environment with env`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `export GREETING=hello; env | grep -E '^(HOME|SHELL|GREETING)='`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2704ms
Sleep 300ms
Type `env -i bash -c 'echo "HOME=[$HOME] PATH=[$PATH]"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6381ms
Sleep 8743ms

# --- .env files: the source trap
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# .env files: the source trap`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat app.env`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4877ms
Sleep 300ms
Type `source app.env; echo "shell: $DB_HOST"; bash -c 'echo "child: [$DB_HOST]"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3498ms
Sleep 300ms
Type `set -a; source app.env; set +a; bash -c 'echo "child: [$DB_HOST:$DB_PORT]"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9004ms

# --- Why sudo drops your variables
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Why sudo drops your variables`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `export DB_HOST=db.local; sudo printenv DB_HOST`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2810ms
Sleep 12370ms
Sleep 300ms
Type `export DB_HOST=db.local; sudo --preserve-env=DB_HOST printenv DB_HOST`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 10407ms
