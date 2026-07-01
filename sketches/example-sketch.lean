import Mathlib
-- import Project.Basic   -- bring in the seabed's definitions once it has some

/-!
Example proof skeleton (replace). The Stage-1 deliverable: a typechecking,
`sorry`-bearing file whose *frozen statement* — the declaration signature — the
human approves and the validator pins. The prover fills in the proof body; the
statement does not change.

Layout contract:
  * the theorem SIGNATURE (keyword … up to `:=`) is frozen — the validator diffs
    it against `<topic>.frozen.lean`;
  * the proof body and any helper lemmas are free to change;
  * no EVOLVE markers. A genuinely unknown constant is an ordinary `def` the proof
    pins — not a searchable slot.
-/

namespace ProjectSketch

-- A constant the statement refers to. If its value is unknown, the proof pins it;
-- there is no evolutionary search over it.
def rate : ℝ := 0

/-- <FILL IN: the real target, citing the source label, e.g. (Source Eq. `<label>`)>.
The signature is frozen; it may mention `rate` but its shape does not change. -/
theorem target_placeholder (x : ℝ) : x * rate = rate * x := by
  -- Fill the proof here, Mathlib-first (loogle / leansearch before custom
  -- tactics). Helper lemmas may be added above.
  sorry

end ProjectSketch
