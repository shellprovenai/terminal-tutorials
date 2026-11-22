# .bashrc vs .profile vs .bash_profile: why your alias works in one terminal and not the other
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs bashrc-vs-profile.tape
Output bashrc-vs-profile.mp4
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
Type `mkdir -p /root && cd /root && clear`
Enter
Type `useradd -m -s /bin/bash demo`
Enter
Type `sed -i '1i echo "-> reading ~/.bashrc"' /home/demo/.bashrc && sed -i '1i echo "-> reading ~/.profile"' /home/demo/.profile`
Enter
Type `echo "alias deploy='echo deploying the app'" >> /home/demo/.bashrc`
Enter
Type `clear`
Enter
Show

# --- The startup files
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The startup files`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls -A /home/demo`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5418ms
Sleep 300ms
Type `tail -n 1 /home/demo/.bashrc`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9696ms

# --- Login shell vs interactive shell
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Login shell vs interactive shell`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `su demo -c "bash -l -c true"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8090ms
Sleep 300ms
Type `grep -A2 'BASH_VERSION' /home/demo/.profile`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9458ms
Sleep 300ms
Type `su demo -c "bash -i -c true" 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 12126ms
Sleep 300ms
Type `su demo -c "bash -l -i -c 'type deploy'" 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2000ms

# --- The trap: creating .bash_profile
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: creating .bash_profile`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `echo 'export PATH="$HOME/bin:$PATH"' > /home/demo/.bash_profile`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6412ms
Sleep 300ms
Type `su demo -c "bash -l -i -c 'type deploy || echo deploy is missing'" 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 12639ms
Sleep 300ms
Type `su demo -c "bash -i -c 'type deploy'" 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6893ms

# --- The fix: one line
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The fix: one line`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `echo '[ -f ~/.profile ] && . ~/.profile' >> /home/demo/.bash_profile && cat /home/demo/.bash_profile`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6432ms
Sleep 300ms
Type `su demo -c "bash -l -i -c 'type deploy'" 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 16758ms
Sleep 9645ms
