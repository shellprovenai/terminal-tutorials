# Solution — lesson 16 practice

**Part 1: an alias for every terminal tab.** A new tab is an interactive, non-login shell, and it reads only
`~/.bashrc`, so the alias goes there (at the end of the file).

**Part 2: login shells.** A login shell reads only the first file it finds out of `~/.bash_profile`, `~/.bash_login` and
`~/.profile`. Because `~/.bash_profile` exists, `~/.profile` is skipped, and with it the lines that load `~/.bashrc`.
One line at the end of `~/.bash_profile` brings the chain back: `~/.bash_profile` → `~/.profile` → `~/.bashrc`.
Its PATH and EDITOR settings stay, and the aliases stay in one place.

```sh
echo "alias logs='tail -n 20 app.log'" >> /work/home/.bashrc
echo '[ -f ~/.profile ] && . ~/.profile' >> /work/home/.bash_profile
```

Test it with `HOME=/work/home bash -l -i -c 'alias'`, then run `sh /practice/check.sh`: all checks should say PASS.
