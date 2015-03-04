#!/bin/bash
#
# Deps: git, pandoc
# Author: Shou Ya (shouyatf@gmail.com)
# License: WTFPL
#

usage() {
    echo "Usage: $0 <issue-no>"      >&2
    echo "Example: $0 23"            >&2
    exit
}

[ "$#" != 1 ] && usage

which git >/dev/null || {
    echo "git not installed."    >&2
    exit
}
which pandoc >/dev/null || {
    echo "pandoc not installed." >&2
    exit
}


tmpdir=`mktemp -d`
issue_no="$1"

cd "$tmpdir"

git clone --depth=1 \
    "https://github.com/ezyang/tmr-issue${issue_no}.git" \
    issue-source \
    >/dev/null 2>&1

cd issue-source

[ -f "Editorial.tex" ] || {
    echo "Editorial source file not found, exiting." >&2
    [ -z "$tmpdir" ] || rm -rf "$tmpdir"
    exit
}


cat <<'EOF'
## Editorial

*by Edward Z. Zhang (ezhang@cs.stanford.edu)*

EOF

cat Editorial.tex | pandoc -f latex -t markdown_strict


[ -z "$tmpdir" ] || rm -rf "$tmpdir"
