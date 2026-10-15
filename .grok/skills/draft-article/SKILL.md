---
name: draft-article
description: >
  Draft a knowledge-base article through NotebookLM. Search and import sources
  into that series notebook, then generate Markdown from
  templates/notebooklm-prompt.md and save it under articles/. Use when the user
  says viết bài, tạo bài, gen bài, thêm nguồn, tìm nguồn, search nguồn, or
  runs /draft-article.
---

# Draft an article

For practical exercises, labs, or a project article, use the sibling
`../draft-practice/SKILL.md` instead. It preserves the source verification rules
while generating an activity rather than a theory explanation.

Read and follow the "Draft an article" section in `AGENTS.md` at the repository root. That section is the procedure for every agent. Do not use a different workflow.

After `notebooklm ask` returns, complete the "Verify" step in that section before creating or editing the article. The answer is not saved as-is.
