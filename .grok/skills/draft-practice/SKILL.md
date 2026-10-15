---
name: draft-practice
description: >
  Write Vietnamese hands-on companions or practical project articles for this
  knowledge base, tied to existing theory and verified NotebookLM sources.
  Use for viết bài thực hành, thêm bài tập, tạo lab, luyện tập theo article,
  or /draft-practice. Also assess whether a series needs practice when asked.
  Do not activate for theory-only drafting or solving a learner's exercise.
---

# Draft practice tied to theory

Work from the repository root. Read `AGENTS.md`, `CONTRIBUTING.md`, the series
README, and the target theory articles. Follow the existing NotebookLM source,
auth, verification, and draft rules; this skill changes the learning activity
and uses `templates/notebooklm-practice-prompt.md` for generation.

## Choose a useful activity

Resolve the series from the request and repository; ask only if ambiguous.
Identify what the reader should be able to **do**, what theory they already
have, and what observable result would demonstrate it. A draft theory article
is context, not evidence for a technical claim.

Use practice when the topic supports a meaningful experiment, artifact,
diagnosis, calculation, or reasoned decision with explicit criteria. Do not
force a coding lab onto a book or conceptual series. A scenario or small
model can fit; an empty worksheet or recap quiz alone does not justify a lab.
When no useful activity fits, explain why rather than manufacture files.

If asked to plan, return the mapping and stop before generation. If asked to
write, proceed with the smallest useful scope. A skill-creation request alone
does not authorize drafting all of its example series.

- **Companion:** practice a mechanism next to its theory in
  `articles/<series>/<article-folder>/practice.md`.
- **Project article:** combine previously learned skills in a numbered
  `index.md`. Reuse an existing project slot before adding a new one. Follow
  the root Save rules for metadata, title, roadmap order, and Previous/Next.

For HTML & CSS Basic, read [the HTML mapping](references/html-css-basic.md).
For other series, derive the mapping from their actual articles. Do not
require concepts from later articles unless introduced as explicit prerequisites.

## Design before generating

Prepare a short brief outside the repository, containing the target article
paths, user-supplied title if any, prerequisite concepts, learning outcomes,
exercise scenario, setup, and observable acceptance criteria. For a whole
series, map outcomes to activities first; combine overlapping exercises and
preserve existing numbering.

Favor a progression from predicting and observing a small example, through
explaining or fixing it, to independently applying the mechanism to a variant.
Use only the stages that help the topic. Reduce scaffolding as the activity
progresses. Include a deliberate failure when it makes the mechanism visible;
state which starter behavior is intentionally broken.

Each task needs a starting state, a concrete change to make, a way to inspect
the result, and a criterion for success. Put hints and a reference solution
after the independent task. Explain why the solution works and accept other
solutions that satisfy the criteria. Avoid giving the finished answer as the
starter or relying solely on visual resemblance.

Use a minimal local environment. List required files and working directory;
provide actual starter contents or tracked files, not missing downloads.
Keep exercises independent or link to an exact earlier starting state. Use
synthetic data and local endpoints for demos; distinguish simulated behavior
from a working backend or external service.

## Source and generate

Read `articles/<series>/notebook.toml`, then perform the root CLI availability
and auth checks. Inspect the notebook's source list using the installed CLI's
help. Select primary sources relevant to the activity; reuse sources already
present. If coverage is missing or the user requested source research, follow
the root Search sources procedure, including the research run id and selective
imports. Keep the selected source ids and their URLs.

Create a temporary prompt outside the repository by combining
`templates/notebooklm-practice-prompt.md` with the brief. Do not edit the shared
prompt for each article. Use it in place of the theory prompt:

```bash
notebooklm ask -n <id> -s <source-id> \
  --prompt-file <temporary-prompt-path> --json --new -y
```

Repeat `-s` for the selected sources only. Keep the JSON answer outside the
repository. Do not use `scripts/draft-article.sh` for a targeted lab, as it asks
every source. Pedagogical references below inform exercise design; they are not
substitutes for HTML, API, or other domain documentation.

## Verify before saving

Complete AGENTS.md's claim-by-claim Verify step against every selected source
URL, including facts inherited from the theory article. Check commands,
syntax, expected behavior, and failure explanations against the active docs.
Exercise names, synthetic data, and task constraints are authored examples;
their claimed behavior still needs evidence. Do not silently revise unrelated
theory while making a companion; report discrepancies separately.

Reproduce the starter, intended failure, and reference solution outside the
repository using the documented setup. Check the actual acceptance criteria,
including the independent variant. For web labs, inspect rendering and
interaction in a browser where available; static inspection alone does not
verify layout, keyboard behavior, or native validation. Do not run intentionally
broken code outside an isolated exercise environment.

When execution tools are unavailable, distinguish source verification from
runtime verification. Only save after source verification passes; identify
unexecuted checks in the delivery report and keep the output a draft. Never
invent measurements, screenshots, execution results, or time-to-complete claims.

## Save and connect

For a companion, follow CONTRIBUTING.md's Practice companions convention.
Add a relative `Thực hành` link from the theory article and a return link from
the companion. Add or update the series README's practice table for companions
actually created, with Draft status; leave theory roadmap statuses alone.
Do not add planned exercises as if files already exist.

Put supplied starter/solution files under that article's `assets/practice/`,
only when useful. Keep starter and solution separate and all references local
and valid. Check Markdown links, file paths, matching metadata/statuses, and
the final diff. Do not commit or publish without a user request.

Report files created, how practice connects to theory, what was executed,
what remains unverified, and claims removed or narrowed with their deciding
source pages, as required by AGENTS.md.

## Design references

- [MDN — Learn web development](https://developer.mozilla.org/en-US/docs/Learn_web_development#test_your_skills): distinguishes isolated skill tests from integrated challenges.
- [PRIMM — Support for teaching programming in school](https://primmportal.com/): Predict, Run, Investigate, Modify, Make; stages need not all appear in each lesson.
- [Teach Computing — Pedagogy](https://teachcomputing.org/pedagogy): worked examples, gradually reduced support, and evaluating artifacts against criteria.

These programming education approaches inform this repository's design choices;
do not claim that they prove effectiveness for every audience or subject.
