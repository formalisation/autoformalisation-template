# Progress log

Running narrative of the formalization — what got done, what's next. Newest
session at the top. Reusable *lessons* (tactics, Mathlib gotchas, API) live in
`CLAUDE.md`; this file is the *story* and the plan.

## Next session — <FILL IN the immediate goal>

<FILL IN: what is done, what is next, and the phased plan. Break the remaining
work into phases with explicit risk levels and a chosen sequencing. Template:>

**Phased plan.**
- **Phase A — <name>** *(DONE / LOW / MEDIUM / HIGH)*. <one-line description; the
  Lean declarations it produces.>
- **Phase B — <name>** *(risk)*. <description; isolate hard sub-results behind a
  hypothesis so downstream work isn't blocked by them.>
- ...

**Sequencing (chosen):** <which order and why — e.g. "do B with the hard
existence result hypothesized; tackle that existence independently later, since
it blocks nothing if B carries it as a hypothesis.">

**Backburner — explicitly deferred:** <FILL IN>.

**Tooling note.** Start the session with `lean-lsp-mcp` loaded and run `lake build`
once up front to warm imports, so the sub-second `lean_goal` /
`lean_diagnostic_messages` loop is live. Per the prove loop (`auto-loop` /
`auto-formalise` skills): Phase 0 is the Stage-1 skeleton — a typechecking
`sketches/<topic>.lean` with the frozen statement + `:= by sorry` body — before any
Phase-A proving. Validate candidates with `scripts/validate`, not just `no_sorry.sh`.

---

## Session <YYYY-MM-DD> — <one-line summary>   *(template entry — copy upward each session)*

**Done.**
- <what landed; name the Lean declarations.>

**Verified.** clean `lake build`; sorry-gate green; capstone `#print axioms =
[propext, Classical.choice, Quot.sound]`; `scripts/validate` clean (frozen statement intact).

**Method that worked.** <the technique, distilled — then copy the reusable core
into CLAUDE.md → Proof tactics.>

**Pitfalls.** <what bit you; the fix — also distilled into CLAUDE.md.>

**Scope honesty.** <what this does and does NOT establish; any derived-side-result
caveat to keep visible in README.>
