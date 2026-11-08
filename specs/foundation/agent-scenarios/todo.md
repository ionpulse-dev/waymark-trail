# Todo: Agent scenarios

## Deferred

- [ ] A headless runner (`claude -p --model <m>` in the run folder, with `--setting-sources project`) for real isolation and saved transcripts. Blocked: the login of the command line tool must be valid.
- [ ] Scenarios for more cases: a push that `origin` rejects, a collision of two new files with one name, a document over 100 KB, the table shown again after a setting change, a large vault of 200 documents.
- [ ] A trend over time: keep every round in `results.md` with the skill version.

## Open Questions

- Should a model score of less than 100 percent on a scenario block a release?
