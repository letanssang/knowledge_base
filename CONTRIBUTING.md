# Contributing

This repository is a personal engineering knowledge base. Articles are Markdown files, and Git history is the version history. The layout stays portable so a site generator or a cross-posting step can be added later without moving files.

## Writing philosophy

Learn → Understand → Apply → Write.

An article should not be a rewrite of documentation. It should answer:

- What is it?
- Why does it exist?
- What problem does it solve?
- How does it work?
- What can go wrong?
- How is it applied in practice?
- What did I learn from it?

Write it after using the idea, or after studying it carefully enough to explain the mechanism and the failure modes in your own words.

## Language

`README.md` at the repository root is Vietnamese, like the articles. `CONTRIBUTING.md` stays English.

Series descriptions and article bodies are Vietnamese when `language` is `vi`. `language` defaults to `vi`.

A Vietnamese explanation may keep established English technical terms. Do not translate a term only for the sake of translating it. Terms that stay in English include authentication, authorization, attack surface, runtime, dependency, reverse engineering, secure storage, and threat model.

## Layout

```text
articles/<topic>/README.md
articles/<topic>/<article-folder>/index.md
articles/<topic>/<article-folder>/assets/<file>
templates/article.md
```

- Directory names and asset file names are lowercase kebab-case. macOS is case-insensitive; GitHub is not.
- An article is a folder with `index.md`, so a static-site generator can map the folder to a URL later. A topic or series landing page is `README.md`, so GitHub renders it.
- A series article folder has a numeric prefix (`01-owasp-masvs`). A standalone article folder has no numeric prefix.
- The prefix orders the series on GitHub. `series_order` in front matter is the metadata source. The two must match.
- The series `README.md` is the source of truth for series order. Previous and next links inside an article are written by hand and follow that order.
- Do not create a topic subfolder until it has an article. Backend areas such as `spring-boot` and `database` wait until then.
- Git does not track empty directories. Give each topic a short `README.md` of one or two sentences on scope. Do not add `.gitkeep` files.
- Create an `assets/` directory only when a file is placed in it.

## Front matter

### Practice companions

A focused exercise may live at `articles/<topic>/<article-folder>/practice.md`
beside its theory article. It is supporting material, not a separately numbered
article: no YAML front matter or `series_order`. Keep it a draft during authoring;
it does not publish the parent or change the parent's roadmap status. Add a
relative link from `index.md` and a return link to `./index.md` in the companion.
Only use a level-1 heading when the user supplies a title.

List created companions in a separate practice table in the series README,
with a link to the theory article, a link to `practice.md`, and Draft/Published
status. Publish a companion only when explicitly requested and verified. Put
starter or solution files in `assets/practice/` beside those Markdown files when
needed; keep them separate and link to actual files.

A cumulative project that occupies a series roadmap slot is a normal numbered
`index.md` article and follows all article metadata and navigation rules. Reuse
an existing practical project slot before adding another. The writing workflow
is `.grok/skills/draft-practice/SKILL.md`; its generation prompt is
`templates/notebooklm-practice-prompt.md`.

### Article metadata

Every article starts with YAML front matter. Copy `templates/article.md`.

```yaml
---
title: ""
description: ""

date:
updated:

series: ""
series_order: 1

slug: ""
canonical_url: ""

tags:
  - example

status: draft
language: vi
---
```

Required on every article: `title`, `description`, `tags`, `status`, and `language`.

`date` and `updated` are required when `status` is `published`. Use `YYYY-MM-DD`. Leave both empty on a draft. Never invent a date. When an article already has Git history, use the first commit date of that file as `date` and the last commit date as `updated`.

`status` is `draft` or `published`. Any README that names the article uses the same status, written as Draft or Published. A placeholder is never shown as Published.

`series` is the display name, for example `Mobile Security`. The series slug is the series directory name, such as `mobile-security`. Omit `series` and `series_order` on a standalone article. When `series` is set, `series_order` is required and equals the numeric folder prefix.

`slug` is optional and overrides the folder name as the URL slug. `canonical_url` is optional and is for cross-posting. Do not add platform-specific fields.

## Tags

Lowercase. Use kebab-case when a tag has more than one word. At most four tags per article.

## Assets

Files that belong to one article live in `assets/` next to that article's `index.md`:

```markdown
![Architecture of the request path](./assets/architecture.png)
```

A file used by more than one article lives in `/assets/shared/` and is referenced with a relative path from the article. Create `assets/shared/` only when the first shared file exists.

Every image has descriptive alt text. Asset file names are lowercase kebab-case.

Relative image paths do not display when an article is cross-posted to DEV.to, Hashnode, or Viblo. A future publishing step has to rewrite those paths to absolute URLs. That step is not part of this repository.

## Links

Internal links are relative, and they point at the file. From one article to a sibling in the same series:

```markdown
[OWASP MASVS](../01-owasp-masvs/index.md)
```

Do not link to a directory. GitHub does not render `index.md` when a directory is opened. Do not hardcode a GitHub URL for content inside this repository.

## Markdown

Write articles in the portable subset of CommonMark and GitHub Flavored Markdown:

- Headings
- Lists
- Tables
- Fenced code blocks with a language tag
- Images
- Links

Avoid GitHub-only features unless there is no alternative. That includes alert blocks such as `> [!NOTE]`, Mermaid diagrams, and HTML embeds.

## Drafting with NotebookLM

Each series has its own NotebookLM notebook. The notebook id is `id` in `articles/<series>/notebook.toml`. Sign in once with `notebooklm login`, as described in the root `README.md`. Commands for every coding agent are in the "Draft an article" section of `AGENTS.md`.

The text NotebookLM returns is not a source and is not an article yet. After it returns, and before the article file is created or edited:

1. Search and import the primary sources for the topic: official docs, the book being studied, or other pages the series already treats as sources.
2. Generate the draft from those pages only.
3. Verify that draft against the pages passed to the generator. A control ID, API name, version, tool name, number, or absolute claim ("always", "never", "triệt để") needs a sentence on the page. Delete a claim the page does not support. Rewrite a claim the page states more narrowly. Do not recommend a tool or API the page marks as deprecated. The order and the report to the user are in the "Verify" step of `AGENTS.md`.
4. Rewrite the surviving claims so a later reading explains the mechanism. Do not add a fact in that rewrite, and do not leave the verification notes in the article.
5. Save the result as `status: draft`.

## Adding an article

1. Choose the topic under `articles/`. If the topic does not exist, create `articles/<topic>/README.md` with one or two sentences on scope.
2. If the article is part of a series, update that series README first. It owns the order. Take the next number.
3. Copy `templates/article.md` to `articles/<topic>/<folder>/index.md`. Use `NN-kebab-name` for a series article and `kebab-name` for a standalone article.
4. Fill the front matter. Keep `status: draft` and leave `date` and `updated` empty until the article is ready. On publication, set both dates to real dates and set `status: published`.
5. Set `series` and `series_order` only for a series article, and make `series_order` match the folder prefix.
6. Replace the `example` tag. Use at most four lowercase tags.
7. Write the body. Delete optional sections you do not need. Add references only when the sources are real.
8. If NotebookLM wrote the body, do not trust that text. Check it against the source pages, using the rule in "Drafting with NotebookLM", before the file is saved.
9. Put images in `assets/` beside `index.md`, with kebab-case names and alt text. Use `/assets/shared/` only for a file that more than one article includes.
10. For a series article, add previous and next links by hand. Point them at each `index.md`.
11. Update the series or topic README so its status matches the front matter.
12. Do not add a site generator, workflow, package manifest, or publishing script for this step.
