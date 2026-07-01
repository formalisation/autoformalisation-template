# Criticisms

The criticisms most important to the success of the formalization — not style
nits, but the issues most likely to affect whether the project stays
**mathematically honest**, readable, and able to reach the full result. Keep this
file current; an honest list of known weaknesses is how the project avoids
quietly overclaiming. Re-audit it when a phase lands.

## Critical
*(Issues that, left unaddressed, would make the formalization misleading or block
the central result.)*

1. <FILL IN. The archetype: "the development so far proves a *decoupled / special-
   case* result, but the paper reaches the headline only after <the real
   argument>. Keep this distinction explicit, or the formalization will appear to
   prove the central reduction before it has." >
2. **Difficulty offloaded into a restated-target helper.** Watch for a proof
   that closes the headline by delegating to a helper lemma that *morally restates
   the target* in a slightly different form. `scripts/validate` catches *statement
   mutation* (a frozen declaration signature changing); this *semantic* offloading is
   caught by the Stage-4 Aristotle honesty audit — keep it on the checklist.
3. **Hallucinated "known" lemma.** A step that leans on a lemma asserted to be
   "established in the literature", or an un-resolved Mathlib name. Confirm every cited
   Mathlib lemma resolves (`lean_hover_info`); end-to-end `#print axioms` + the sorry
   gate are the backstop.

## High Priority
*(Real risks to correctness, auditability, or reuse.)*

1. <FILL IN. e.g. stale docs that describe an older state; a hard theorem whose
   *interface* should be designed before implementation; reusable lemmas (an
   invariance fact, an indexing convention) that should be factored out and named
   to match the human proof rather than proved inline.>

## Medium Priority
*(Worth fixing; not blocking.)*

1. <FILL IN. e.g. a proof that verifies an endpoint equation but skips the paper's
   derivation chain — acceptable, but must be documented as a *derived side
   result*, not a substitute for the chain.>

## Recommended next steps
1. <FILL IN — the ordered, concrete actions that discharge the criticisms above.>
