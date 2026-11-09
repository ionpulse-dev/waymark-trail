# Tests: Personal knowledge base skill

_`[auto]` items are verified by running the automated test suite (`sh tests/skills.test.sh` and `sh tests/build.test.sh`). `[manual]` items require a human with a real agent session._

## Acceptance Criteria Coverage

| Criterion | Test Case |
|:----------|:----------|
| **Given** a new session in any folder, with the skill installed globally and the start block in the global instructions file, **When** the agent first uses the skill, **Then** it shows the start message with both rows at Manual. | A1, M1 |
| **Given** a session in a folder that is not the knowledge base, with a path in the instructions of the person, **When** the agent uses the knowledge base, **Then** it finds the root from the path and runs Git as `git -C <root>`. | A12, M10 |
| **Given** reading is Manual, **When** the person does not ask about the knowledge base, **Then** the agent does not search or open documents. | A2, M2 |
| **Given** writing is Manual, **When** the person does not ask for a write, **Then** the agent does not create, change, or move documents. | A3, M3 |
| **Given** the person says "read automatically", **When** the agent answers, **Then** it shows the table with the dot in the Automatic cell of the Reading row and the Writing row unchanged. | A4, M4 |
| **Given** the context was compacted, **When** the next message arrives, **Then** the agent shows the table again. | A4, M5 |
| **Given** a write request, **When** the agent writes, **Then** it pulls first, checks that the document did not change since it read it, commits under the person's name, and writes no secrets. | A5, A9, M6 |
| **Given** a document would exceed the size cap, **When** the agent writes it, **Then** it splits the document or moves details into a linked source. | A6, M7 |
| **Given** a document the agent wrote, **When** it is checked against MKBase 1.0, **Then** it conforms. | A7, M6 |
| **Given** the agent creates the marker folder, **When** it commits, **Then** the commit holds `.mkbase/version`, `.mkbase/exclude` with the line `README.md`, and a `README.md` that points to waymark-trail and holds no skill rules. | A11, M8 |
| **Given** a knowledge base with no `README.md`, **When** the agent uses it, **Then** it offers to add one and never overwrites an existing `README.md`. | A11, M9 |
| **Given** the skill file is opened on its own, **When** it is read, **Then** it contains everything needed, with no include and no mention of a settings file. | A8, A10 |

## Test Cases

- [x] [auto] A1: The personal skill contains the start message with the table, both rows with the dot in the Manual cell (`tests/skills.test.sh`).
- [x] [auto] A2: The skill says that Reading Manual means searching and opening documents only when the person asks (`tests/skills.test.sh`).
- [x] [auto] A3: The skill says that Writing Manual means no create, change, or move without a request, and that only the person changes a setting (`tests/skills.test.sh`).
- [x] [auto] A4: The skill lists when to show the table again: after a change, after a question, after compaction (`tests/skills.test.sh`).
- [x] [auto] A5: The skill lists the write steps: pull with rebase, compare the last commit, commit under the person's name, no force push (`tests/skills.test.sh`).
- [x] [auto] A6: The skill states the 100 KB cap and the split rule (`tests/skills.test.sh`).
- [x] [auto] A7: The skill lists every document field, the file name rules, the link rules, and the title and description limits (`tests/skills.test.sh`).
- [x] [auto] A8: The skill has no include, and no line of the body repeats a line of the frontmatter (`tests/build.test.sh`).
- [x] [auto] A9: The skill has a rule against secrets and a rule to ask when unsure (`tests/skills.test.sh`).
- [x] [auto] A10: The skill does not mention other tools, a settings file, or a config file (the link to waymark-trail in the README template is allowed), and stays below 16 KB (`tests/skills.test.sh`).
- [x] [auto] A11: The skill has the rule for the `README.md` of the knowledge base: create it with the marker folder, list it in `.mkbase/exclude`, offer it when missing, never overwrite (`tests/skills.test.sh`).
- [x] [auto] A12: The skill looks at the path from the instructions first, searches the current folder only without a path, runs `git -C <root>`, and has no "in this repository" (`tests/skills.test.sh`).
- [ ] [manual] M1: The start message.
  1. Create a test repository with a `.mkbase` folder (with the file `version` that says `1.0`) and one valid document. Install the skill in the global skill folder of the agent tool, as the README says. Add the start block from the README to the global instructions file, with the path of the test repository.
  2. Start a new agent session in another folder and send "hello".
  3. Expected: the agent shows the start message with the name of the knowledge base, its path, and the table, with the dot in the Manual cell of both rows, and nothing more.
  4. Cleanup: delete the test repository, the global skill file, and the start block.
- [ ] [manual] M2: Reading Manual.
  1. In the session from M1, ask a question that is not about the knowledge base, for example "what is 12 times 12?".
  2. Expected: the agent answers and does not search or open any document.
- [ ] [manual] M3: Writing Manual.
  1. In the same session, say "I learned that our build needs Node 22."
  2. Expected: the agent does not create or change a document. It may offer to write one.
- [ ] [manual] M4: Change a setting.
  1. Say "read automatically".
  2. Expected: the agent shows the table with the dot in the Automatic cell of the Reading row, and the Writing row is still Manual.
- [ ] [manual] M5: Compaction.
  1. Run the compaction command of the tool in the same session, then send any message.
  2. Expected: the agent shows the table again before it answers.
- [ ] [manual] M6: A valid write.
  1. Say "write a document about why we chose Postgres. Reason: it supports our JSON queries."
  2. Expected: one new file below the folder that holds the `.mkbase` folder with a lowercase file name and all required fields, correct dates, and your Git name and email in `created_by` and `updated_by`. One commit under your name with a message that starts with `kb:`. The agent pulled before it wrote and pushed after.
  3. Cleanup: delete the test repository and its remote.
- [ ] [manual] M7: Size cap.
  1. Ask the agent to write one document from a text of more than 100 KB.
  2. Expected: the agent splits the text into linked documents, each below 100 KB, or moves the details into a linked source.

## Notes

- The manual checks need a real agent and a test repository with a remote you can delete.
- Run M1 to M7 again after every change to `src/common.md` or `src/personal.md`.
- [ ] [manual] M8: README with the marker folder.
  1. In an empty folder, start a session and ask the agent to create a knowledge base there.
  2. Expected: one commit `kb: add marker folder` with `.mkbase/version`, `.mkbase/exclude` (line `README.md`), and `README.md`. The `README.md` links to waymark-trail and holds no rules.
  3. Cleanup: delete the test folder.
- [ ] [manual] M9: README offered, never overwritten.
  1. Use a knowledge base with no `README.md`. Ask a question about it.
  2. Expected: the agent answers and offers once to add a `README.md`. After "yes", one commit `kb: add "README"` and the line `README.md` in `.mkbase/exclude`.
  3. Change the `README.md` by hand, start a new session, and ask again. Expected: the agent does not overwrite it.
- [ ] [manual] M10: A session in another folder.
  1. Use the setup of M1. Start a session in an empty folder, and ask "what does my knowledge base say about <topic of the valid document>?".
  2. Expected: the agent finds the knowledge base from the path in the global instructions, answers from the document, and runs Git with `git -C <path>`.
