"""Wrap single-statement `if` bodies that dart format split over two lines.

Usage: python3 tool/brace_ifs.py <file.dart>...
Matches only `if (...)` lines followed by one indented line ending in `;`.
"""
import re, sys

pat = re.compile(r'^(?P<ind>[ \t]*)(?P<head>(?:else )?if \(.*\))\n(?P<body>[ \t]+[^\n{}]*;)\n', re.M)
for path in sys.argv[1:]:
    s = open(path).read()
    def fix(m):
        ind = m.group('ind')
        return f"{ind}{m.group('head')} {{\n{m.group('body')}\n{ind}}}\n"
    new = pat.sub(fix, s)
    if new != s:
        open(path, 'w').write(new)
        print('fixed', path)
