# <PROJECT> — project memory for Claude Code

Lean 4 + Mathlib formalization of <FILL IN: the result(s) and primary source —
author, title, venue, arXiv id>. The compiled paper is `papers/<source>.pdf`;
source/notes in `papers/`. Keep this file short; it is the single source of truth
for accumulated lessons, so they persist across machines. Update it (or run
/memory) when a convention, tactic, or decision stabilizes.

## Scope (what is formalized)
<FILL IN: one bullet per module, naming the Lean declaration and the source
equation/section it corresponds to. Example shape:>
- `<Project>/Basic.lean` — <core definitions + the headline statement>, `<Decl>`
  (Source Eq. `<label>`).

**Deferred, not yet formalized:** <FILL IN>. **Do not stub these** — add them as
real theorems when the time comes. An honest skeleton with more `sorry`s beats a
dishonest one with fewer (a `sorry` under a *correct* statement documents what
remains; a `sorry` under a *wrong* statement creates false confidence).

## Conventions
- **Mathlib naming/style/tactics**: follow [`.claude/skills/lean-references/`](.claude/skills/lean-references/README.md)
  — `mathlib-style.md` before naming any new declaration; the tactic / proof-golfing /
  refactoring notes on stuck or finished proofs. Shared source of truth; cite, don't copy.
- Cite the source equation/section label (e.g. `<label>`) in each theorem's
  docstring, so a human can audit the Lean against the paper.
- **Skeleton-first**: get a correct *statement* compiling before filling the
  proof. A wrong statement is worse than a visible gap.
- **Skeleton-first (frozen statement)**: the unit of work is a `sketches/<topic>.lean`
  whose target theorem is stated with a `:= by sorry` body. After human sign-off the
  *statement* (declaration signature) is frozen — pin a read-only copy at
  `sketches/<topic>.frozen.lean` as the validator baseline; the proof body is then free
  to change. No EVOLVE markers, no searchable-value slots, no evolutionary reseed. See
  `docs/DESIGN.md` and `sketches/README.md`.
- **Mathlib-first**: on every subgoal, search Mathlib (`lean_loogle` /
  `lean_leansearch` / `lean_state_search` / `lean_hammer_premise`, then `rg`
  `.lake/packages/mathlib/`) *before* a custom tactic or helper, and prefer a Mathlib
  discharge in the final proof. Confirm a cited lemma actually resolves
  (`lean_hover_info`) — an unresolved name is a hallucination, not a TODO. Don't
  contort the frozen statement to fit a Mathlib structure.
- <FILL IN: domain conventions — regime hypotheses carried explicitly, notation,
  which Mathlib structures you align against, sign/index conventions.>

## Proof Workflow

**The prove loop (Stages 1 → 3 → 4).** The idea becomes a *compiling skeleton*
(frozen statement + `:= by sorry` body) before any hard proving. Stage 3 may fan out
**N independent prover subagents**, each in its own `git worktree`, each Ralph-looping
on the skeleton with per-turn `lean-lsp-mcp` feedback and the Mathlib-first escalation
ladder (Mathlib → tactics → `codex` counterexample → **Aristotle** formal oracle on a
stuck subgoal); keep the first to reach validated green (plain parallelism — no
evolutionary reseed). A candidate is *validated green* only when `scripts/validate
<frozen-skeleton> <file>` passes: every frozen declaration *signature* byte-identical to
the baseline, compiles, `scripts/no_sorry.sh` clean, capstone `#print axioms`
trusted-only. Aristotle then critiques complex proofs for the *semantic* honesty
failures the signature-diff can't see (target-restating helper, hallucinated "known"
lemmas). Full spec: the `auto-loop` / `auto-formalise` skills + `docs/DESIGN.md`.

**Skeleton correctness takes priority over filling in sorries.** A sorry with a correct statement is valuable (it documents what remains to prove); a sorry with a wrong statement is actively harmful (it creates false confidence and wasted work downstream). When auditing reveals incorrect lemma statements, fix them before working on other tractable sorries — even in other files. An honest skeleton with more sorries beats a dishonest one with fewer.

**Verify theorem statements against the source paper early.** Before building infrastructure, read the primary source to confirm: (1) single application or repeated/recursive? (2) essential tree structures or bookkeeping? (3) definitions match exactly? Informal sources can mislead about the precise result. Read primary sources at the design stage.

**Formalization adds lemmas for implicit hypotheses.** When an informal proof says "X follows because the construction has property P," the formal proof needs an explicit predicate for P and a lemma proving the construction satisfies it. Having more intermediate lemmas than the paper is EXPECTED — the extra lemmas make implicit paper assumptions explicit. Don't conflate "fewer lemmas" with "closer to the paper"; the paper's argument structure matters more than its lemma count.

Before attempting a `sorry`, estimate the probability of proving it directly (e.g., 30%, 50%, 80%) and report this. If the probability is below ~50%, first factor the `sorry` into intermediate lemmas — smaller steps that are each individually likely to succeed. This avoids wasting long build-test cycles on proofs that need restructuring.

**Recognize thrashing and ask the user.** After 3+ failed approaches to the same goal, stop and ask for guidance. Signs: repeated restructuring, oscillating between approaches, growing helper count without progress. A 2-minute conversation is cheaper than 30 minutes of failed builds.

**Never silently abandon an agreed plan.** If a plan was approved and a step turns out harder than expected, do NOT silently switch to a shortcut (e.g., replacing a proof with `native_decide` or `sorry`). Always confirm radical plan changes with the user first — explain what's hard, what the alternatives are, and let them decide. A 2-minute conversation about changing course is far cheaper than discovering the change broke assumptions downstream.

**Assess proof risk before significant work.** Break non-trivial theorems into phases with risk levels: LOW (definition, direct proof), MEDIUM (standard argument, uncertain details), HIGH (novel connection, unclear if approach works). Identify the highest-risk phase, document fallback plans (axiomatize, defer, reformulate), and validate the critical bottleneck lemma before building dependencies. Escalate to user after 2-3 failed attempts on a MEDIUM+ phase.

**Analyze uncertain lemmas in natural language before formal proof attempts.** Work through the math with concrete examples BEFORE formalizing: (1) test the proof idea with specific numbers, (2) look for counterexamples, (3) verify each step informally, (4) only then formalize. Informal analysis is instant vs. 20s-2min build cycles. A careful analysis can reveal a lemma is unprovable (saving days) or clarify the exact proof structure needed.

**Keep proofs small and factored.** If a proof has more than ~3 intermediate `have` steps, factor them into standalone lemmas. Each lemma should have a small, independently testable interface — this avoids churning where fixing one step breaks steps below it.

**When a user suggests an approach or lesson, rephrase it for CLAUDE.md** rather than copying verbatim. Lessons should be concise, actionable, and fit the existing style.

**Work autonomously on low-risk tasks once the path is clear.** When reduced to well-understood engineering (Mathlib interfacing, type bridging, assembling existing components), continue autonomously. Check in when hitting unexpected obstacles, discovering the approach won't work, or completing major milestones. Progress over permission when risk is low.

**Review subtle definitions interactively before building downstream infrastructure.** Definitions that involve distinguishability (e.g., 0-1 values vs labeled elements) or quantifier structure (∀ permutations vs ∀ Boolean sequences) can be subtly wrong in ways that only surface when attempting proofs. When a definition is the foundation for multiple sorry'd lemmas, validate it with the user before committing to downstream work.

**"Easy to see" in papers is a red flag for formalization.** When a paper says "it is easy to see" without proof, validate the *proof strategy* — not just the statement — before investing in Lean infrastructure. Always ask: "what is the proof, not just the claim?"

## Proof tactics
*(Build out as we go.)* After completing each proof, reflect: if there's a
reusable lesson — a tactic pattern, a Mathlib gotcha, a refactor that unlocked
progress — add it here (not in auto memory). When the user suggests an approach,
**rephrase it concisely** for this file rather than copying verbatim.

- <FILL IN as you go. Seed example of the right altitude:> Prefer `exact`/defeq
  over `convert`/syntactic when the goal's function is a `def`/`fun` and the
  lemma's is a `Pi`-op — `rw` the derivative *value* into the combinator form,
  then `exact`.

## Mathlib API reference
*(Build out as we go — record exact signatures; they are not reliably memorable.
Grep the source — `grep -rn "theorem <name>" .lake/packages/mathlib/Mathlib/` —
rather than recalling argument order / `_root_.` prefixes.)*

- <FILL IN: the lemmas this project actually leans on, with exact signatures and
  the file they live in.>

## MCP tooling and `lake` fallback
`.mcp.json` wires up **`lean-lsp-mcp`** (`uvx lean-lsp-mcp`), talking to a
persistent `lake serve` LSP. **Use the MCP tools as the default check-loop — read
the goal state and diagnostics after every edit rather than guessing — and
reserve `lake build` for full verification.** A warm LSP query is sub-second; a
full `lake build` re-elaborates against all of Mathlib, so it is the fallback,
not the inner loop. Run `lake build` once at session start to warm imports.

Core loop (LSP-backed, fast, no network):
- `lean_diagnostic_messages` — all errors/warnings for a file; the primary "did
  my edit compile?" check.
- `lean_goal` — tactic state at a line/column; the workhorse for stepping a proof.
- `lean_term_goal` — expected type at a term hole.
- `lean_hover_info` — docs + signature for a symbol.
- `lean_completions` — identifiers/imports valid at a position.
- `lean_declaration_file` / `lean_references` — read a lemma's source / find uses.
- `lean_multi_attempt` — try several tactics at one position, compare resulting
  goals, pick the winner without a rebuild.
- `lean_run_code` — run an independent snippet (`#check` / `#eval`).
- `lean_verify` — list the axioms a finished proof uses; scan for unsafe code.

Lemma search (local first; the rest are external, rate-limited ~3 req / 30 s):
- `lean_local_search` — ripgrep over the local project + stdlib (needs `rg`).
- `lean_loogle` — Mathlib search by name / subexpression / type signature.
- `lean_leansearch` — natural-language search over Mathlib.
- `lean_state_search` / `lean_hammer_premise` — theorems / premises for the goal.

Fallback / recovery:
- `lean_build` (MCP) or `lake build` (shell) — full build + restart the LSP; use
  when LSP state goes stale.

Plain shell build (CI and first checkout):
    lake exe cache get      # once: download prebuilt Mathlib oleans
    lake build              # full verification
    bash scripts/no_sorry.sh
    scripts/validate sketches/<topic>.frozen.lean sketches/<topic>.lean   # frozen-stmt + sorry gate
