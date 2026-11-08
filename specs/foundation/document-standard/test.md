# Tests: Document standard

## Acceptance Criteria Coverage

| Criterion | Test Case |
|:----------|:----------|
| **Given** the standard, **When** it is read, **Then** it has the required sections and two annexes. | S1 |
| **Given** a valid document of the conformance set, **When** the checker runs, **Then** it passes. | S2 |
| **Given** an invalid document of the conformance set, **When** the checker runs, **Then** it fails and names the broken rule. | S3 |
| **Given** the standard and a finished skill, **When** their field tables are compared, **Then** they are identical. | S4 |
| **Given** the sample vault, **When** it is opened in Obsidian, **Then** properties, links, tags, and the graph show without errors. | S5 |

## Test Cases

- [x] [auto] S1: The standard has sections 1 to 10 and Annex A and Annex B, and uses the words MUST, SHOULD, and MAY (`tests/standard.test.sh`).
- [x] [auto] S2: The checker passes every document in the sample vault (`tests/standard.test.sh`).
- [x] [auto] S3: The checker fails every document in `invalid/` and prints the rule named by the file (`tests/standard.test.sh`).
- [x] [auto] S4: The field table of the standard equals the field table of both finished skills, and the default limits match (`tests/standard.test.sh`).
- [ ] [manual] S5: Obsidian opens the sample vault.
  1. Open Obsidian, choose "Open folder as vault", and select `standard/conformance/vault`.
  2. Open each document. Open the Properties view and the graph view.
  3. Expected: properties show with the right types (dates as dates, lists as lists), links work, tags show in the tag pane, and the graph shows the link between the two payment documents. Obsidian shows no errors.
  4. Write the Obsidian version into section 10 of the standard and into `todo.md`.
  5. Cleanup: none. Do not commit the `.obsidian` changes that Obsidian makes beyond `app.json`.

## Notes

- Run S5 again before each release of the standard.
