#!/bin/sh
# setup.sh — builds the home folder of a developer in /work/home: Debian's default .bashrc and .profile with a few
# personal aliases, plus a .bash_profile that a guide told them to create (the classic trap).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
H="$W/home"
rm -rf "$H"
mkdir -p "$H/bin"
cp /etc/skel/.bashrc /etc/skel/.profile "$H/"
cat >> "$H/.bashrc" <<'EOF'

# my aliases
alias ll='ls -alF'
alias gs='git status'
EOF
cat > "$H/.bash_profile" <<'EOF'
# added after reading a blog post about PATH
export PATH="$HOME/bin:$PATH"
export EDITOR=nano
EOF
printf '#!/bin/sh\necho "hello from ~/bin"\n' > "$H/bin/hello"
chmod +x "$H/bin/hello"
echo
cat /practice/TASK.md 2>/dev/null || true
