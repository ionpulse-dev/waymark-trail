#!/bin/sh
# Print a table from a results file written by grade.sh (RESULTS_FILE).
# Usage: summarize.sh <results.tsv>
python3 -I - "$1" <<'PY'
import sys, collections
rows = [l.rstrip("\n").split("\t") for l in open(sys.argv[1]) if l.strip()]
by = collections.defaultdict(lambda: collections.defaultdict(lambda: [0, 0]))
fails = collections.defaultdict(collections.Counter)
models = []
for s, label, r, failed in (r + [""] * (4 - len(r)) for r in rows):
    m = label.split("-")[0]
    if m not in models: models.append(m)
    by[s][m][0] += r == "PASS"; by[s][m][1] += 1
    for f in filter(None, failed.split("|")): fails[s][f] += 1
print("%-26s" % "scenario" + "".join("%-10s" % m for m in models))
tot = collections.defaultdict(lambda: [0, 0])
for s in sorted(by):
    line = "%-26s" % s
    for m in models:
        p, n = by[s][m]; tot[m][0] += p; tot[m][1] += n
        line += "%-10s" % ("%d/%d" % (p, n) if n else "-")
    print(line)
print("%-26s" % "TOTAL" + "".join("%-10s" % ("%d/%d" % tuple(tot[m])) for m in models))
print()
for s in sorted(fails):
    for f, c in fails[s].most_common(): print("  %s: %s (%dx)" % (s, f, c))
PY
