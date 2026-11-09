# Tests: Document standard

## Acceptance Criteria Coverage

| Criterion | Test Case |
|:----------|:----------|
| **Given** the standard, **When** it is read, **Then** it has the required sections and two annexes. | S1 |
| **Given** a valid document of the conformance set, **When** the checker runs, **Then** it passes. | S2 |
| **Given** an invalid document of the conformance set, **When** the checker runs, **Then** it fails and names the broken rule. | S3 |
| **Given** the standard and a finished skill, **When** their field tables are compared, **Then** they are identical. | S4 |
| **Given** the sample vault, **When** the tests run, **Then** it has the required size and variety, and every document passes the checker. | S2, S6 |
| **Given** a folder with a `.mkbase` folder, **When** a tool looks for the root, **Then** the marker folder defines the root, and excluded files and hidden files are not documents. | S7 |
| **Given** a wikilink in a property that names a missing document, **When** the checker runs, **Then** it fails. | S3 |
| **Given** the sample vault, **When** it is opened in Obsidian, **Then** properties, links, tags, and the graph show without errors. | S5 |

## Test Cases

- [x] [auto] S1: The standard has sections 1 to 10 and Annex A and Annex B, and uses the words MUST, SHOULD, and MAY (`tests/standard.test.sh`).
- [x] [auto] S2: The checker passes every document in the sample vault (`tests/standard.test.sh`).
- [x] [auto] S3: The checker fails every document in `invalid/` and prints the rule named by the file. It also fails a property wikilink to a missing document (`broken-wikilink`) (`tests/standard.test.sh`).
- [x] [auto] S4: The field table of the standard equals the field table of both finished skills, and the default limits match (`tests/standard.test.sh`).
- [x] [auto] S6: The vault has at least 15 documents, at least 4 over 20 KB, at least 2 over 40 KB, a deprecated, a disputed, and a superseding document, anchors, a `trust` field, non-ASCII text, and a callout (`tests/standard.test.sh`).
- [x] [auto] S7: The sample vault has a marker folder with a `version` file, an `exclude` file, and a file of a tool. An excluded file is skipped. A file that is not excluded is checked. An excluded folder is skipped. A file in the marker folder is not a document (`tests/standard.test.sh`).
- [ ] [manual] S5: Obsidian opens the sample vault.
  1. Open Obsidian, choose "Open folder as vault", and select `standard/conformance/vault`. The folder holds the folder `.mkbase`, which Obsidian hides.
  2. Open each document. Open the Properties view and the graph view.
  3. Expected: properties show with the right types (dates as dates, lists as lists), links work, tags show in the tag pane, and the graph shows the link between the two payment documents. Obsidian shows no errors.
  4. Write the Obsidian version into section 10 of the standard and into `todo.md`.
  5. Cleanup: none. Do not commit the `.obsidian` changes that Obsidian makes beyond `app.json`.

## Notes

- Run S5 again before each release of the standard.
