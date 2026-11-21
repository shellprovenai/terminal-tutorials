# Undo anything in Git: restore vs reset vs revert (live demos)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs git-undo.tape
Output git-undo.mp4
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
Type `mkdir -p /lab/shop && cd /lab/shop && clear`
Enter
Type `git init -q -b main && git config user.name Demo && git config user.email demo@example.com && git config --global color.ui false`
Enter
Type `echo "price = 10" > app.conf && git add . && git commit -qm "Add config"`
Enter
Type `echo "currency = EUR" >> app.conf && git commit -qam "Add currency"`
Enter
Type `echo "debug = true" >> app.conf && git commit -qam "Enable debug"`
Enter
Type `clear`
Enter
Show

# --- The demo repository
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The demo repository`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git log --oneline`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3379ms
Sleep 7697ms

# --- 1. Throw away an edit: git restore
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 1. Throw away an edit: git restore`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `echo "price = 0" >> app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4554ms
Sleep 300ms
Type `git status --short`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3125ms
Sleep 300ms
Type `git restore app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2469ms
Sleep 300ms
Type `cat app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3686ms
Sleep 7207ms

# --- 2. Unstage a file: git restore --staged
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 2. Unstage a file: git restore --staged`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `echo "tax = 23" >> app.conf && git add app.conf && git status --short`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2104ms
Sleep 4184ms
Sleep 300ms
Type `git restore --staged app.conf && git status --short`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3918ms
Sleep 300ms
Type `git restore app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7855ms

# --- 3. Undo the last commit, keep the changes: reset --soft
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 3. Undo the last commit, keep the changes: reset --soft`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 7015ms
Sleep 300ms
Type `git reset --soft HEAD~1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7314ms
Sleep 300ms
Type `git status --short && git log --oneline`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `git commit -qm "Enable debug (only in dev)" && git log --oneline`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5568ms

# --- 4. Drop a commit with reset --hard, then get it back
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 4. Drop a commit with reset --hard, then get it back`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 8438ms
Sleep 300ms
Type `git reset --hard HEAD~1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8914ms
Sleep 300ms
Type `cat app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `git reflog | head -3`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8900ms
Sleep 300ms
Type `git reset --hard "HEAD@{1}" && git log --oneline`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3797ms
Sleep 10642ms

# --- 5. Undo a shared commit: git revert
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 5. Undo a shared commit: git revert`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 9526ms
Sleep 300ms
Type `git revert --no-edit HEAD`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3863ms
Sleep 300ms
Type `git log --oneline && cat app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 9511ms
