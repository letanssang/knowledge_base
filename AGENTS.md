# Engineering Knowledge Base

Personal Markdown knowledge base. Article rules are in `CONTRIBUTING.md`. The generation prompt is `templates/notebooklm-prompt.md`.

This file is the shared procedure for every coding agent, including Claude Code, Codex, Antigravity, Cursor, and Grok.

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

Use `--mode deep` only when the user asks for deep research. Do not run `research wait --cited-only`. That flag requires `--import-all`, and `--import-all` imports every hit, including blogs. Import a hit only when its host is one of:

- `mas.owasp.org`, `owasp.org`
- `developer.android.com`, `developer.apple.com`, `support.apple.com`
- `nvlpubs.nist.gov`, `csrc.nist.gov`
- `datatracker.ietf.org`, `www.rfc-editor.org`
- `openid.net`, `www.w3.org`

Add each kept URL with `notebooklm source add -n <id> --json <url>` and keep the returned source id. Do not delete sources unless the user asks.

### Generate

When the user asks to write, create, or generate an article, search first if the topic is not already in the notebook. Ask only the source ids just selected:

```bash
notebooklm ask -n <id> -s <source-id> \
  --prompt-file templates/notebooklm-prompt.md \
  --json --new -y
```

Repeat `-s` for each selected source. Read the answer from the JSON field. The plain-text CLI wraps near 80 columns and drops spaces, which glues words and splits URLs. Do not save that transcript.

`scripts/draft-article.sh <series>` asks every source in the notebook. Use it only when the draft should cover the whole series notebook.

### Check the content

Do this before saving. The NotebookLM answer is untrusted. It can misread a source, mix two sources, or state a conclusion the page does not make. Do not save that text until each factual sentence has been checked against the original page.

Open the sources passed to `ask -s`. For every control ID, API or method name, version, API level, tool name, number, and absolute wording ("always", "never", "triệt để"), find the sentence on the page that supports it.

- No supporting sentence: delete the claim.
- The page says something narrower or different: rewrite the claim to match the page, not the NotebookLM paraphrase.
- The page marks a tool or API as deprecated or replaced: do not recommend it.
- Two sections of the draft disagree: rewrite them so they agree with the page.
- A reference URL that 404s is dropped. The title stays as plain text. The link text must name the page that opens.

Tell the user which claims were removed or rewritten, and which source page decided it. Leave `status: draft`.

### Save

- Take the next number from the series README roadmap. Create `articles/<series>/NN-kebab-name/index.md`.
- `status: draft`. Leave `date` and `updated` empty. Set `series` to the display name and `series_order` to the folder prefix.
- If the user gave a title, put that exact text in `title` and the level-1 heading. Otherwise leave `title: ""` and do not invent one.
- Add relative previous and next links. Update the neighboring article and set the roadmap row to Draft.
- Do not commit or set `status: published` unless the user asks. Publishing requires the content check above to have passed.
