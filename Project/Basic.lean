import Mathlib

/-!
# Core definitions

<FILL IN: one paragraph naming the primary source and the objects this module
introduces. Follow the conventions in CLAUDE.md:>

* cite the source equation/section label in each declaration's docstring;
* **skeleton-first** — a correct *statement* with a `sorry` is fine while you
  work, but committed code is `sorry`-free (the gate in `scripts/no_sorry.sh`
  enforces it). Replace the `sorry` before committing.

Primary source: <FILL IN: Author(s), *Title*, venue, arXiv id>.
-/

namespace Project

/-- Seed example (replace). A trivially true statement so the template builds
clean and CI is green out of the box. Each real declaration gets a docstring that
states, in words, what it means and cites the source label it formalizes. -/
theorem placeholder : (0 : ℝ) = 0 := rfl

-- To add a result, work skeleton-first:
--
--   /-- <what it means>  (Source Eq. `<label>`). -/
--   theorem my_result (hyps) : conclusion := by
--     sorry   -- correct STATEMENT first; fill the proof, then the gate goes green
--
-- Use the `lean-lsp-mcp` tools (lean_goal / lean_diagnostic_messages) as the
-- inner loop; reserve `lake build` for full verification. See CLAUDE.md.

end Project
