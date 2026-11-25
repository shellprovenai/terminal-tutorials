PRACTICE — lesson 16: .bashrc vs .profile vs .bash_profile
----------------------------------------------------------
/work/home is the home folder of a developer. Their aliases (ll,
gs) work in every new terminal tab, but over SSH they are gone.
You can try both kinds of shell with that home folder:
  new terminal tab:  HOME=/work/home bash -i -c 'alias'
  SSH login shell:   HOME=/work/home bash -l -i -c 'alias'

1. Add the alias  logs='tail -n 20 app.log'  so that every new
   terminal tab (interactive, non-login shell) has it.
2. Make login shells get all the aliases too. Keep .bash_profile
   and what it sets (PATH with ~/bin, EDITOR); don't copy the
   aliases into more than one file.

Check: sh /practice/check.sh     Answer: /practice/solution.md
