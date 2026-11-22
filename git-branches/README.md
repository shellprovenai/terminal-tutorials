# Git branches without fear: create, switch, merge, delete, and recover a deleted branch

> 🎬 Video: https://youtu.be/rG944XI3pBk (public from Nov 30, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Create and switch: git switch -c

```console
$ git switch -c feature/login
Switched to a new branch 'feature/login'
```

```console
$ echo "login form" > login.txt && git add login.txt && git commit -qm "Add login form" && git log --oneline --decorate --all --graph
* f2ad00c (HEAD -> feature/login) Add login form
* fcc1e4f (main) First version
```

## Merge: fast-forward

```console
$ git switch main && git merge feature/login
Switched to branch 'main'
Updating fcc1e4f..f2ad00c
Fast-forward
 login.txt | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 login.txt
```

## Merge: a real merge commit

```console
$ git switch -c feature/search && echo "search box" > search.txt && git add . && git commit -qm "Add search box"
Switched to a new branch 'feature/search'
```

```console
$ git switch main && echo "v2" > app.txt && git commit -qam "Update app to v2"
Switched to branch 'main'
```

```console
$ git merge --no-edit feature/search && git log --oneline --decorate --graph
Merge made by the 'ort' strategy.
 search.txt | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 search.txt
*   eb7698e (HEAD -> main) Merge branch 'feature/search'
|\  
| * eeb4ef6 (feature/search) Add search box
* | 747dc4d Update app to v2
|/  
* f2ad00c (feature/login) Add login form
* fcc1e4f First version
```

## Delete: -d refuses, -D forces

```console
$ git branch -d feature/login feature/search
Deleted branch feature/login (was f2ad00c).
Deleted branch feature/search (was eeb4ef6).
```

```console
$ git switch -c experiment && echo "risky idea" > idea.txt && git add . && git commit -qm "Try a new idea" && git switch main
Switched to a new branch 'experiment'
Switched to branch 'main'
```

```console
$ git branch -d experiment
error: the branch 'experiment' is not fully merged
hint: If you are sure you want to delete it, run 'git branch -D experiment'
hint: Disable this message with "git config advice.forceDeleteBranch false"
```

```console
$ git branch -D experiment
Deleted branch experiment (was 6cc69eb).
```

## Recover a deleted branch with the reflog

```console
$ git log -g --oneline --grep="new idea"
6cc69eb HEAD@{1}: commit: Try a new idea
```

```console
$ git branch experiment $(git log -g --format=%h --grep="new idea" -1) && git log --oneline experiment -2
6cc69eb Try a new idea
eb7698e Merge branch 'feature/search'
```

## Quick check

**Question 1.** git branch -d says the branch is not fully merged. What does that mean?

**Answer:** It has commits that are not merged into your current branch — Deleting it would drop work that exists nowhere else. Merge it first, or use capital -D only if you're sure.

**Question 2.** I deleted a branch with git branch -D. How do I get it back?

**Answer:** Find the commit in the reflog, then git branch name <commit> — A branch is only a name. The reflog still knows the commit, so you recreate the name there.

Commands that check the answers (run in the same container, after the lesson):

```console
$ git switch -q -c quiz && echo q > q.txt && git add . && git commit -qm "Quiz commit" && git switch -q main

```

```console
$ git branch -d quiz
error: the branch 'quiz' is not fully merged
hint: If you are sure you want to delete it, run 'git branch -D quiz'
hint: Disable this message with "git config advice.forceDeleteBranch false"
```

```console
$ git branch -D quiz && git branch quiz $(git log -g --format=%h --grep="Quiz commit" -1) && git branch --list quiz
Deleted branch quiz (was cdea8ee).
  quiz
```

## Files

- `setup.sh` — demo folder
- `git-branches.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
