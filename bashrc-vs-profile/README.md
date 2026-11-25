# .bashrc vs .profile vs .bash_profile: why your alias works in one terminal and not the other

> 🎬 Video: https://youtu.be/MIiZMT6JqLU (public from Nov 25, 2026)
> 📝 Lesson page with a short quiz: https://shellprovenai.github.io/lekcje/bashrc-vs-profile/

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The startup files

```console
$ ls -A /home/demo
.bash_logout
.bashrc
.profile
```

```console
$ tail -n 1 /home/demo/.bashrc
alias deploy='echo deploying the app'
```

## Login shell vs interactive shell

```console
$ su demo -c "bash -l -c true"
-> reading ~/.profile
-> reading ~/.bashrc
```

```console
$ grep -A2 'BASH_VERSION' /home/demo/.profile
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
```

```console
$ su demo -c "bash -i -c true" 2>/dev/null
-> reading ~/.bashrc
```

```console
$ su demo -c "bash -l -i -c 'type deploy'" 2>/dev/null
-> reading ~/.profile
-> reading ~/.bashrc
deploy is aliased to `echo deploying the app'
```

## The trap: creating .bash_profile

```console
$ echo 'export PATH="$HOME/bin:$PATH"' > /home/demo/.bash_profile

```

```console
$ su demo -c "bash -l -i -c 'type deploy || echo deploy is missing'" 2>/dev/null
deploy is missing
```

```console
$ su demo -c "bash -i -c 'type deploy'" 2>/dev/null
-> reading ~/.bashrc
deploy is aliased to `echo deploying the app'
```

## The fix: one line

```console
$ echo '[ -f ~/.profile ] && . ~/.profile' >> /home/demo/.bash_profile && cat /home/demo/.bash_profile
export PATH="$HOME/bin:$PATH"
[ -f ~/.profile ] && . ~/.profile
```

```console
$ su demo -c "bash -l -i -c 'type deploy'" 2>/dev/null
-> reading ~/.profile
-> reading ~/.bashrc
deploy is aliased to `echo deploying the app'
```

## Quick check

**Question 1.** I created ~/.bash_profile and now my aliases are gone over SSH. Why?

**Answer:** A login shell now reads ~/.bash_profile and skips ~/.profile, so ~/.bashrc never loads — Bash reads only the first of those files. Source dot profile from dot bash underscore profile to fix it.

**Question 2.** Where should an alias go so every new terminal tab has it?

**Answer:** ~/.bashrc — Interactive shells read dot bash r c. Keep environment variables in dot profile instead.

Commands that check the answers (run in the same container, after the lesson):

```console
$ cat /home/demo/.bash_profile
export PATH="$HOME/bin:$PATH"
[ -f ~/.profile ] && . ~/.profile
```

```console
$ su demo -c "bash -l -i -c 'type deploy'" 2>/dev/null
-> reading ~/.profile
-> reading ~/.bashrc
deploy is aliased to `echo deploying the app'
```

```console
$ su demo -c "bash -i -c 'type deploy'" 2>/dev/null
-> reading ~/.bashrc
deploy is aliased to `echo deploying the app'
```

## Practice

Try it yourself, without the video: `practice/start.sh` opens a throwaway container (podman or docker) with the task, `sh /practice/check.sh` tells you when you're done, `practice/solution.md` has the answer. Tested: `practice-test.log` (FAIL before, PASS after the solution).

## Files

- `setup.sh` — demo folder
- `bashrc-vs-profile.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
