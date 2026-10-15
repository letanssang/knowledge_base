# Engineering Knowledge Base

Personal Markdown knowledge base. Article rules are in `CONTRIBUTING.md`. The generation prompt is `templates/notebooklm-prompt.md`.

This file is the shared procedure for every coding agent, including Claude Code, Codex, Antigravity, Cursor, and Grok.

## Draft practice

For hands-on companions, exercises, labs, or practical project articles, read
`.grok/skills/draft-practice/SKILL.md`. It applies the NotebookLM and Verify
procedure below with `templates/notebooklm-practice-prompt.md`, and uses the
Practice companions convention in `CONTRIBUTING.md` for companion files.
Assess whether practice suits the topic; do not require a lab for every series.

## Draft an article

Each series is one NotebookLM notebook. Run the commands below. Do not restate the article format.

### Config

- Notebook id: `articles/<series>/notebook.toml`, field `id`. This is the last segment of `https://notebooklm.google.com/notebook/<id>`.
- Sign-in: `notebooklm login` stores the session in `~/.notebooklm`. There is no `.env`. Never ask the user to paste cookies or tokens into chat.
- A topic becomes a series when it gets `notebook.toml` and a roadmap in its `README.md`. One notebook per series.

If `id` is empty, ask once for the notebook URL, write the id into that file, then continue.

### Before calling NotebookLM

1. Resolve the series directory under `articles/`.
2. Read its `notebook.toml`.
3. If `notebooklm` is missing, stop and give the user:

```bash
uv tool install "notebooklm-py[browser]"
notebooklm login
```

4. Run `notebooklm auth check --test --json`. If it is not ok, tell the user to run `notebooklm login` and stop.

### Search sources

When the user asks to find or add sources, or the notebook has no sources for the requested topic:

```bash
notebooklm source add-research "<query>" -n <id> --mode fast --from web --no-wait --json
notebooklm research status -n <id> --run-id <task_id> --json
```

Pass `--run-id` from the start response. Without it, status fails once the notebook has more than one research run.

Use `--mode deep` only when the user asks for deep research. Do not run `research wait --cited-only`. That flag requires `--import-all`, and `--import-all` imports every hit, including blogs.

Import a research hit only when it satisfies two core principles:

1. **Authoritative & Primary Sources:**
   - Prioritize primary documentation directly from standards bodies, dedicated organizations, original authors, or official platform portals.
   - Avoid secondary roundups, personal blogs, Q&A forums, or aggregator mirrors.
   - For technical topics, authoritative hosts include: `whatwg.org`, `developer.mozilla.org`, `w3.org`, `datatracker.ietf.org`, `rfc-editor.org`, `nvlpubs.nist.gov`, `owasp.org`, `developer.apple.com`, `developer.android.com`.
   - For other fields (books, history, science, governance): choose reputable publishers, academic institutions, official reports, or primary archival records.

2. **Recency & Superseded Check:**
   - **Reject superseded materials**: Never source from specifications, drafts, or documents that are obsolete, retired, or historical (labeled "Superseded", "Retired", "Obsolete", "Discontinued", or kept in archival directories). Always seek the latest active standard.
   - **Identify the current governing body**: When authority or stewardship over a standard or topic shifts between bodies (e.g., WHATWG governing HTML/DOM living standards vs. W3C governing CSS/WCAG), reference the organization actively maintaining the effective standard.


Add each kept URL with `notebooklm source add -n <id> --json <url>` and keep the returned source id. Do not delete sources unless the user asks.

### Generate

When the user asks to write, create, or generate an article, search first if the topic is not already in the notebook. Ask only the source ids just selected:

```bash
notebooklm ask -n <id> -s <source-id> \
  --prompt-file templates/notebooklm-prompt.md \
  --json --new -y
```

Repeat `-s` for each selected source. Read the answer from the JSON field. The plain-text CLI wraps near 80 columns and drops spaces, which glues words and splits URLs. Do not save that transcript.

`scripts/draft-article.sh <series>` asks every source in the notebook and prints the answer. It does not check or save an article. Use it only when the draft should cover the whole series notebook.

### Verify

Do this after `notebooklm ask` returns, before creating or editing the article file. The answer is untrusted. It can misread a source, mix two sources, or state a conclusion the page does not make.

1. Keep the JSON `answer` outside the repository. Do not paste it into `index.md`.
2. List each factual claim a reader could act on: control ID, API or method name, version, API level, tool name, number, and absolute wording ("always", "never", "triệt để").
3. Open every URL passed with `-s`. For each claim, find the sentence on one of those pages that supports it.
4. No supporting sentence: drop the claim. The page is narrower or different: keep the page's wording. The page marks a tool or API as deprecated or replaced: do not recommend it. Two claims disagree: keep the one that matches the page. A reference URL that 404s is dropped. The title stays as plain text. The link text must name the page that opens.
5. Rewrite only the claims that survived, in the voice of `templates/notebooklm-prompt.md`. Do not add a fact during that rewrite. The check stays out of the article: no "the page says", no note of which sentence was corrected. Source titles and URLs belong in References.
6. Tell the user which claims were removed or rewritten, and which source page decided it.

Saving before this step is not allowed. Leave `status: draft`.

### Save

- Take the next number from the series README roadmap. Create `articles/<series>/NN-kebab-name/index.md`.
- `status: draft`. Leave `date` and `updated` empty. Set `series` to the display name and `series_order` to the folder prefix.
- If the user gave a title, put that exact text in `title` and the level-1 heading. Otherwise leave `title: ""` and do not invent one.
- Add relative previous and next links. Update the neighboring article and set the roadmap row to Draft.
- Do not commit or set `status: published` unless the user asks. Publishing requires the verify step above to have passed.
