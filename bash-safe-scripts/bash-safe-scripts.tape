# Bash scripts that don't destroy things: set -euo pipefail, quoting, [[ ]] and ${VAR:?}
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs bash-safe-scripts.tape
Output bash-safe-scripts.mp4
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
Type `mkdir -p /lab/scripts && cd /lab/scripts && clear`
Enter
Type `mkdir -p /lab/scripts/build && touch /lab/scripts/build/old.o`
Enter
Type `printf '#!/bin/bash\ncd /lab/scripts/biuld\necho "cleaning in: $(pwd)"\n' > clean.sh`
Enter
Type `printf '#!/bin/bash\nset -e\ncd /lab/scripts/biuld\necho "cleaning in: $(pwd)"\n' > clean-safe.sh`
Enter
Type `touch "my notes.txt" draft.txt`
Enter
Type `clear`
Enter
Show

# --- set -e: stop at the first error
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# set -e: stop at the first error`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat clean.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6986ms
Sleep 300ms
Type `bash clean.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `bash clean-safe.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6746ms
Sleep 4583ms

# --- set -u and ${VAR:?}: no silent empty variables
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# set -u and ${VAR:?}: no silent empty variables`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `unset BUILD_DIR; echo rm -rf "$BUILD_DIR/"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6740ms
Sleep 300ms
Type `bash -c 'set -u; echo rm -rf "$BUILD_DIR/"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6721ms
Sleep 300ms
Type `bash -c 'BUILD_DIR=""; echo rm -rf "${BUILD_DIR:?is empty}/"'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7123ms

# --- pipefail: failures inside a pipeline
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# pipefail: failures inside a pipeline`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `grep ERROR missing.log | wc -l; echo "exit code: $?"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7008ms
Sleep 300ms
Type `set -o pipefail; grep ERROR missing.log | wc -l; echo "exit code: $?"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 5826ms

# --- Quote your variables
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Quote your variables`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `file="my notes.txt"; ls -l $file`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4117ms
Sleep 300ms
Type `file="my notes.txt"; ls -l "$file"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4229ms
Sleep 300ms
Type `for f in *.txt; do echo "found: $f"; done`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3309ms

# --- [[ ]] instead of [ ]
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# [[ ]] instead of [ ]`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `answer=""; [ $answer = yes ] && echo "yes"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `answer=""; [[ $answer == yes ]] || echo "not yes"; name="report.csv"; [[ $name == *.csv ]] && echo "a CSV file"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2984ms

# --- Let shellcheck find it for you
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Let shellcheck find it for you`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `printf '#!/bin/bash\ncd $1\nrm -rf $DIR/*\nfor f in $(ls); do echo $f; done\n' > bad.sh && cat bad.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4423ms
Sleep 300ms
Type `shellcheck -f gcc bad.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 9191ms
