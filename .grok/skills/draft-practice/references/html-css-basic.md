# HTML & CSS Basic: practice mapping

Read the actual articles and roadmap before using this proposal. This is a
design reference, not an additional roadmap or a set of completed labs.

The series already has `10-hands-on-landing-page/index.md`. Use companions for
focused practice, then reuse article 10 when asked for a cumulative project.
Avoid another landing-page article or renumbering articles 01–10.

| Theory | Proposed activity | Evidence the learner produces |
| --- | --- | --- |
| 01: first HTML page, DOM | Create a small page, predict its structure, inspect it, edit a node in DevTools, then reload | Compare saved source and observed DOM before/after reload; explain the difference |
| 02: semantic structure | Mark up a supplied event announcement with headings, regions, and navigation | Explain element choices by content purpose, inspect document structure and follow navigation links |
| 03: forms | Build a local event registration form and repair missing labels or submitted field names | Check label interaction, keyboard use, invalid input, and actual submitted field names using a documented local receiver |
| 04: cascade, box model | Diagnose a card whose measured size differs from the prediction, then isolate a conflicting rule | Compare predicted and measured dimensions and identify the winning declaration in DevTools |
| 05: units, typography, colors | Modify the event page's text scale and colors under declared constraints | Record the relevant computed values and explain which reference each chosen unit uses |
| 06: normal flow, positioning | Position a badge on a card, then repair a deliberately incorrect containing context | Observe the reference box and explain the effect on neighboring content |
| 07: Flexbox | Build a navigation row and adapt it to longer labels or less available width | Check wrapping, alignment, and overflow under the task's explicit widths and content |
| 08: Grid | Lay out event cards and vary card count and available width | Compare track arrangement and content overflow against explicit criteria |
| 09: responsive design | Adapt the event page to narrow and wide layouts | Test declared viewport widths, long content, and keyboard access; record failures and fixes |
| 10: existing landing-page project | Independently combine structure, form, typography, and layout using a brief | Deliver working files plus a criterion-by-criterion explanation, including failure cases |

Use the event scenario across labs only when each starting state is supplied
or explicitly linked. For example, article 02's learner should not need CSS
from article 07 to complete its core task. JavaScript, frameworks, package
managers, and a remote backend are not default prerequisites. Keep DOM work
in article 01 to the concepts necessary for that exercise; do not make its
advanced API digressions mandatory beginner tasks.

Select current primary pages that support each lab's exact mechanisms. WHATWG
HTML and DOM, relevant active CSS specifications, MDN, and W3C accessibility
guidance are candidate sources, not evidence until their pages are opened and
checked. Avoid treating old References in the draft articles as already verified.

For forms, document exactly where data goes and how it is observed. A static
demo must not claim to register a user or send mail. Do not assume opening a
file URL reproduces HTTP submission; choose and verify a minimal local setup
when that behavior is part of the exercise.

For visual work, provide a text wireframe or explicit layout constraints when
helpful, and test behavior beyond a screenshot. Validation, semantic structure,
keyboard checks, and responsive checks are separate checks; passing one does
not establish complete accessibility or SEO. Do not promise pixel identity
across browsers or universal device compatibility.
