# Git branches without fear: create, switch, merge, delete, and recover a deleted branch
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs git-branches.tape
Output git-branches.mp4
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
Type `echo "v1" > app.txt && git add . && git commit -qm "First version"`
Enter
Type `clear`
Enter
Show

# --- Create and switch: git switch -c
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Create and switch: git switch -c`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git switch -c feature/login`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6792ms
Sleep 300ms
Type `echo "login form" > login.txt && git add login.txt && git commit -qm "Add login form" && git log --oneline --decorate --all --graph`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 6055ms

# --- Merge: fast-forward
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Merge: fast-forward`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git switch main && git merge feature/login`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 9676ms

# --- Merge: a real merge commit
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Merge: a real merge commit`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git switch -c feature/search && echo "search box" > search.txt && git add . && git commit -qm "Add search box"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `git switch main && echo "v2" > app.txt && git commit -qam "Update app to v2"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `git merge --no-edit feature/search && git log --oneline --decorate --graph`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1989ms
Sleep 3117ms

# --- Delete: -d refuses, -D forces
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Delete: -d refuses, -D forces`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git branch -d feature/login feature/search`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5189ms
Sleep 300ms
Type `git switch -c experiment && echo "risky idea" > idea.txt && git add . && git commit -qm "Try a new idea" && git switch main`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `git branch -d experiment`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `git branch -D experiment`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7972ms
Sleep 5223ms

# --- Recover a deleted branch with the reflog
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Recover a deleted branch with the reflog`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `git log -g --oneline --grep="new idea"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4410ms
Sleep 300ms
Type `git branch experiment $(git log -g --format=%h --grep="new idea" -1) && git log --oneline experiment -2`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2429ms
Sleep 8103ms
