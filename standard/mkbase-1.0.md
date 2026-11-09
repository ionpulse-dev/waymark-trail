# MKBase Document Standard

**Version:** 1.0
**Date:** 2026-11-08
**Short name:** MKBase 1.0

---

## 1 Scope

This standard defines one document of a knowledge base: a Markdown file with a
YAML header. It defines the file name, the header fields, the body, the links,
and the size limits. It defines which values are fixed and which a knowledge
base may change.

This standard does not define how a person or a program reads or writes
documents, how a repository is laid out outside the root folder of a knowledge base, or
how a document is shown.

## 2 Conformance

### 2.1 Key words

The words "MUST", "MUST NOT", "SHOULD", "SHOULD NOT", and "MAY" are used as
described in RFC 2119.

### 2.2 Conformance classes

- **Conforming document.** A document that follows every MUST and MUST NOT of
  sections 6 to 9.
- **Conforming knowledge base.** A root folder with a marker folder (section 5) in
  which every document is a conforming document. A conforming knowledge base
  MUST NOT need a central index file that writers edit. Generated index files MAY
  exist.
- **Conforming producer.** A person or a program that creates or changes
  documents. A conforming producer MUST produce conforming documents. It MUST set
  `updated` and `updated_by` on every change. It MUST NOT create or change a
  document outside the root of the knowledge base. It MUST NOT move or rename
  an existing document without fixing every link that the change breaks. It MUST keep the parts of a document that it does not
  understand, such as callouts and comments written by people.

A claim of conformance MUST name the version, for example "conforms to MKBase
1.0".

## 3 Normative references

- UTF-8 (RFC 3629)
- YAML 1.2
- CommonMark
- RFC 2119 (key words)

## 4 Terms and definitions

- **document.** One Markdown file of a knowledge base. It holds one topic.
- **knowledge base.** The set of documents below one root.
- **root.** The folder that contains the marker folder `.mkbase`.
- **marker folder.** The folder `.mkbase` in the root. It defines the root and holds the metadata and the configuration of the knowledge base.
- **frontmatter.** The YAML header at the start of a document.
- **property.** One key and its value in the frontmatter.
- **ID.** The path of a document below the root, without `.md`.
- **producer.** A person or a program that writes documents.
- **consumer.** A person or a program that reads documents.

## 5 Knowledge base root and marker folder

1. A knowledge base has a root: a folder that contains a folder named `.mkbase`.
   This folder is the marker folder.
2. The marker folder holds the metadata and the configuration of the knowledge
   base. Its content is open. This version of the standard defines only the
   files in rule 3 and rule 4.
3. The marker folder MUST contain a file `version`. It holds the version of this
   standard that the knowledge base follows, for example `1.0`, in UTF-8 text.
   (A file is needed because Git does not store an empty folder.)
4. The marker folder MAY contain a file `exclude`. It is UTF-8 text. A line that
   is empty or starts with `#` is ignored. Every other line names a file or a
   folder, as a path relative to the root and without a leading `/`. A named file
   or folder, and everything below a named folder, is not part of the knowledge
   base.
5. A tool SHOULD keep its own files in the marker folder in a subfolder or with
   a name that carries the name of the tool, for example
   `.mkbase/example-tool/settings.toml`. A consumer MUST ignore files in the
   marker folder that it does not know. A producer MUST keep them.
6. A file or a folder whose name starts with `.` is not part of the knowledge
   base. This includes the marker folder.
7. Every file with the extension `.md` below the root is a document, except the
   files that are excluded by rule 4 or rule 6. A file with another extension is
   not a document.
8. The ID of a document is its path below the root without `.md`, for example
   `backend/payments/idempotency-keys`.
9. The root MAY be the root of a repository, or any folder in it. This standard
    names no folder. To keep other Markdown files, such as a `README.md`, out of
    the knowledge base, a knowledge base excludes them in `exclude`, or puts the
    marker folder in a subfolder.
10. A program finds the root as the first folder that contains a marker folder,
    going up from the file or folder in question.
11. A later version of this standard MAY define more files in the marker folder.

## 6 Document structure and file names

1. A document MUST be UTF-8 text with LF line ends and the extension `.md`.
2. A document MUST hold one topic.
3. A document MUST NOT be larger than the document limit (section 9).
4. A document MUST start with frontmatter: a line `---`, the properties, and a
   closing line `---`. The body follows.
5. A file name MUST use only lowercase letters `a` to `z`, digits, and `-`, then
   `.md`.
6. A file name is a short form of the title. A producer SHOULD NOT change it
   when the title changes. A rename changes the ID of the document, like a move
   (section 5), and the producer MUST fix the links that it breaks.
7. The ID of a document is defined in section 5.
8. A knowledge base MUST NOT hold binary data. A document describes it and links
   to it.

## 7 Frontmatter fields

Properties MUST be flat. A value MUST be text, a number, a checkbox (`true` or
`false`), a date in the form `YYYY-MM-DD`, or a list of strings. A value MUST NOT
be an object.

| Field | Required | Meaning |
|---|---|---|
| `title` | yes | One sentence, at most 15 words. |
| `description` | yes | What the document contains and when to read it. At most 50 words. |
| `status` | yes | `active` or `deprecated`. |
| `created`, `updated` | yes | Dates. |
| `created_by`, `updated_by` | yes | Text `"Name <email>"`. |
| `disputed` | no | `true` when someone found the document wrong. |
| `dispute_reason` | no | Text. Set together with `disputed: true`. |
| `sources` | no | List of strings: ticket IDs or URLs. |
| `tags` | no | List of strings, no `#`, no spaces. |
| `related` | no | List of full-path wikilinks: read these too. |
| `supersedes` | no | List of full-path wikilinks: this document replaces an older one. The older one becomes `deprecated`. |
| `anchors` | no | List of strings `"<type>:<target>"` that point to the file or page the document describes. Types: `git` (`<repo>/<path>@<commit>`) and `url`. |
| `trust`, `verified_by`, `verified` | no | Only when the knowledge base uses verification. Never set these yourself. Keep them as they are. |

Rules for the fields:

1. A field marked "yes" MUST be present and MUST NOT be empty.
2. `title`, `description`, `status`, `created`, `updated`, `created_by`,
   and `updated_by` MUST appear in every document.
3. `created` and `updated` MUST be dates. `updated` MUST NOT be earlier than
   `created`.
4. `created_by` and `updated_by` MUST have the form `"Name <email>"`. The email
   SHOULD be reachable.
5. `disputed: true` MUST come with a `dispute_reason`.
6. A producer MUST NOT add an inline `#tag` to the body. It MUST use `tags`.
7. `supersedes` MUST name the replaced document, and the replaced document
   SHOULD have `status: deprecated`.
8. A producer MUST NOT set `trust`, `verified_by`, or `verified` unless the
   knowledge base uses verification. A producer MUST keep these fields as they
   are when it changes a document, unless a verification process changes them.
9. A consumer MUST ignore properties that it does not know. A producer MUST keep
   them.

## 8 Links

1. A link in the body MUST be a relative Markdown link with the extension `.md`,
   or a wikilink. A producer SHOULD write relative Markdown links.
2. A link in a property MUST be a wikilink with the full path, in quotes, for
   example `"[[backend/payments/retry-policy]]"`.
3. A link SHOULD point to an existing document.
4. A document MUST NOT store its backlinks. A consumer computes them.

## 9 Size limits

| Part | Default |
|---|---|
| Whole document | 102400 bytes (100 KB). This limit is a hard cap. |
| `title` | 15 words |
| `description` | 50 words |

There is no limit on the words in the body. A producer that would exceed the
document limit MUST split the document or move details into a linked source.

## 10 Configurable parameters

A knowledge base MAY change the values below. A producer MUST use the values of
the knowledge base it writes to. If the knowledge base names no value, the
default applies. How a knowledge base names its values is not defined here.

| Parameter | Default | Note |
|---|---|---|
| Document limit | 102400 bytes | |
| Title limit | 15 words | |
| Description limit | 50 words | |

Everything else in this standard is fixed. A knowledge base MUST NOT change the
field names, the field types, the file name rules, or the link forms.

## 11 Obsidian compatibility

Obsidian is a product. It has no formal specification, and it can change. This
standard does not use it as a normative reference. Obsidian finds a vault by
its `.obsidian` folder. MKBase finds a knowledge base by its `.mkbase` folder.

1. A conforming document SHOULD open in Obsidian without errors. Its properties,
   links, tags, and graph SHOULD work.
2. This standard is a stricter subset of what Obsidian accepts. It fixes
   lowercase file names, flat properties, and full-path wikilinks in properties,
   which Obsidian leaves open.
3. A consumer and a producer MUST accept callouts, embeds, highlights, and
   comments that people wrote in the body. They are not errors. A word count
   ignores their markup.
4. A knowledge base that is used with Obsidian SHOULD set the options
   `"useMarkdownLinks": true` and `"newLinkFormat": "relative"` in
   `.obsidian/app.json`. Then Obsidian writes the link form that section 8
   requires. Without them, Obsidian writes wikilinks with short paths in the body.
   Other files of the `.obsidian` folder are personal settings. This standard does
   not say whether to keep them in Git.

## Annex A (informative) Examples

A valid document:

```markdown
---
title: The payment API uses idempotency keys on every write
description: Explains how clients must send an idempotency key with each payment request and what happens on a retry. Read it before you call the payment API.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Jane Doe <jane.doe@corp.example.org>"
updated_by: "Jane Doe <jane.doe@corp.example.org>"
tags:
  - payments
  - api
related:
  - "[[backend/payments/retry-policy]]"
---

# Idempotency keys

A client sends the header `Idempotency-Key` with every write. The server
stores the result for 24 hours. See the [retry policy](retry-policy.md).
```

Examples of invalid documents are in `standard/conformance/invalid/`. Each file
is named for the rule that it breaks.

## Annex B (informative) Conformance test set

The folder `standard/conformance/` holds:

- `vault/`: a sample vault with 18 documents, from a few lines to about 50 KB.
  The marker folder is `vault/.mkbase`. It holds `version`, an `exclude` file
  that excludes `README.md`, and a file of an example tool. The vault has
  a deprecated, a disputed, and a superseding document, links between folders,
  callouts, and non-ASCII text.
  Every document in it is a conforming document. The vault opens in Obsidian and
  is used for the compatibility check of section 11.
- `invalid/`: documents that are not conforming. Each file name names the broken
  rule.
- A reference checker, `tests/check-document.sh`, checks the rules that a shell
  can check, including that wikilinks in properties name existing documents. It
  passes every document of `vault/` and fails every document of `invalid/`.

The checker is a tool for this test set. A document is conforming when it follows
this standard, whatever a tool says.
