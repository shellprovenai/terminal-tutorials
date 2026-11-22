# .gitignore not working? Untrack files that are already committed (git rm --cached)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs gitignore-untrack.tape
Output gitignore-untrack.mp4
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
Type `mkdir -p /lab/repo && cd /lab/repo && clear`
Enter
Type `git init -q -b main && git config user.name Demo && git config user.email demo@example.com && git config --global color.ui false`
Enter
Type `mkdir -p logs build && echo "print('hi')" > app.py && echo "API_KEY=demo-secret-123" > .env && echo "started" > logs/app.log && echo "bin" > build/app.bin`
Enter
Type `git add . && git commit -qm "Initial commit" && git clone -q . /lab/teammate`
Enter
Type `clear`
Enter
Show

# --- The problem
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The problem`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git ls-files`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9418ms
Sleep 300ms
Type `printf '.env\n*.log\nbuild/\n' > .gitignore && echo "more" >> logs/app.log && git status --short`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 6802ms

# --- Why: .gitignore only applies to untracked files
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Why: .gitignore only applies to untracked files`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 10727ms
Sleep 300ms
Type `git check-ignore -v --no-index logs/app.log .env build/app.bin`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5968ms
Sleep 5778ms

# --- The fix: git rm --cached
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The fix: git rm --cached`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git rm -q --cached .env logs/app.log && git rm -q -r --cached build && git status --short`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4375ms
Sleep 300ms
Type `ls -A && ls logs build`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4474ms
Sleep 300ms
Type `git add .gitignore && git commit -qm "Stop tracking .env, logs and build" && echo "again" >> logs/app.log && git status --short && echo "clean"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 11830ms

# --- Surprise 1: the secret is still in history
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Surprise 1: the secret is still in history`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git show HEAD~1:.env`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5359ms
Sleep 15052ms

# --- Surprise 2: teammates lose their local copy
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Surprise 2: teammates lose their local copy`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cd /lab/teammate && ls -A && git pull -q && ls -A`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4482ms
Sleep 15350ms
