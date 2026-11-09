# Tests: Team knowledge base skill

_`[auto]` items are verified by running `sh tests/skills.test.sh` and `sh tests/build.test.sh`. `[manual]` items require a human with a real agent session._

## Acceptance Criteria Coverage

| Criterion | Test Case |
|:----------|:----------|
| **Given** a new session in any folder, with the skill installed globally and the start block in the global instructions file, **When** the agent first uses the skill, **Then** it shows the start message with both rows at Manual and the line about commits and visibility. | B1, N1 |
| **Given** the agent creates the marker folder or finds a knowledge base with no `README.md`, **When** it writes, **Then** it follows the README rules of the personal skill: `README.md` in the root, listed in `.mkbase/exclude`, never overwritten. | B8, N7 |
| **Given** the behaviour shared with the personal skill, **When** the same situation occurs, **Then** the team skill behaves the same way. | B2, N2 |
| **Given** the agent writes a document, **When** it commits, **Then** the commit author is the person's own name and a reachable email. | B3, N3 |
| **Given** the agent finds a document that contradicts its source, **When** the person agrees to act, **Then** the agent sets `disputed` with a reason and does not delete the document. | B4, N4 |
| **Given** a document contains something that looks like a secret, **When** the agent is about to write it, **Then** it stops and asks the person. | B5, N5 |
| **Given** two versions of one document collide, **When** the agent syncs, **Then** it keeps both versions as two files and reports it. | B6, N6 |

## Test Cases

- [x] [auto] B1: The team skill contains the start message with the table, the line "(shared with your team)", and the line about commits and visibility (`tests/skills.test.sh`).
- [x] [auto] B2: The shared rules are in the team skill exactly as in the personal skill (`tests/skills.test.sh`).
- [x] [auto] B3: The skill requires the person's own name and a reachable email, lists unusable address parts, and says there is no separate author for the agent (`tests/skills.test.sh`).
- [x] [auto] B4: The skill says to set `disputed: true` with a reason, to not rewrite another team's document on its own, and that a deprecated document stays (`tests/skills.test.sh`).
- [x] [auto] B5: The skill has the secret rule with the instruction to stop and ask (`tests/skills.test.sh`).
- [x] [auto] B6: The skill has the collision rule with the `-conflict.md` file and the rule to never leave a conflict state (`tests/skills.test.sh`).
- [x] [auto] B7: The skill has no mention of other tools or a settings file, and stays below 17 KB (`tests/skills.test.sh`).
- [x] [auto] B8: The skill has the rule for the `README.md` of the knowledge base (`tests/skills.test.sh`).
- [x] [auto] B9: The skill has the same path rules as the personal skill (`tests/skills.test.sh`).
- [ ] [manual] N1: The start message.
  1. Create a test repository with a `.mkbase` folder (with the file `version` that says `1.0`) and one valid document. Install the skill in the global skill folder of the agent tool, as the README says. Add the start block from the README to the global instructions file, with the path of the test repository.
  2. Start a new session in another folder and send "hello".
  3. Expected: the start message with "(shared with your team)", the table with both rows at Manual, and the line about commits and visibility.
  4. Cleanup: delete the test repository, the global skill file, and the start block.
- [ ] [manual] N2: Same behaviour as the personal skill. Repeat M2 to M5 of `personal-knowledge-base/test.md` with the team skill. Expected: the same results.
- [ ] [manual] N3: Commit author.
  1. Set `git config user.name "Test Person"` and `git config user.email "test.person@corp.example.org"` in the test repository.
  2. Ask the agent to write a document.
  3. Expected: `git log -1 --format='%an <%ae>'` shows that name and address, and the document's `created_by` has the same text.
  4. Repeat with `user.email` set to `x@users.noreply.github.com`. Expected: the agent stops and asks for a real address.
- [ ] [manual] N4: Dispute.
  1. Add a document that says the project uses port 3000. Make the code use port 4000.
  2. Ask the agent "is the port document right?", then say "yes, mark it".
  3. Expected: the document has `disputed: true` and a `dispute_reason`. The file still exists.
- [ ] [manual] N5: Secret.
  1. Ask the agent to write a document that includes the line `password = hunter2hunter2`.
  2. Expected: the agent stops and asks. No file is written.
- [ ] [manual] N6: Collision.
  1. Clone the test repository twice (A and B). In A, change the body of a document and push. In B, change the same document and ask the agent to write it.
  2. Expected: no conflict state remains in B. The remote version is in the original file. The version from B is in `<file-name>-conflict.md` with `disputed: true`. The agent reports it.
  3. Cleanup: delete both clones and the remote.

## Notes

- Run N1 to N6 again after every change to `src/common.md` or `src/team.md`.
- [ ] [manual] N7: README of the knowledge base. Repeat M8 and M9 of `personal-knowledge-base/test.md` with the team skill. Expected: the same results.
- [ ] [manual] N8: A session in another folder. Repeat M10 of `personal-knowledge-base/test.md` with the team skill. Expected: the same result.
