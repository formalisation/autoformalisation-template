# Design

This is a template for **LLM-assisted, interactive formalization** of a specific
mathematical result in Lean 4 + Mathlib. The agent (Claude Code) does the
formalization directly — reading the paper, writing statements and proofs against
a live Lean LSP — and the project's structure is the discipline that keeps the
output **honest and verifiable**.

It is not a batch "autoformalization pipeline" (no LLM translates a corpus and an
eval harness scores it). That is a different kind of project; this one matches how
real single-paper formalizations are actually built.

## Reference repos

The structure is distilled from three projects of exactly this shape:

- **[`girving/aks`](https://github.com/girving/aks)** (Geoffrey Irving) — the AKS
  sorting network in Lean 4, authored by Claude Code. Source of: a `#print axioms`
  / sorry-audited trust boundary, a `CLAUDE.md` of accumulated tactics, empirical
  (Rust) cross-checks of the theorem statements, and a README that is candid about
  its (astronomical, unoptimised) constants.
- **[`timaeus-research/laplace`](https://github.com/timaeus-research/laplace)**
  (Murfet's group / Timaeus) — the anharmonic Laplace asymptotic from the SLT
  Susceptibility Primer. Source of: the headline-theorem README with a file map
  and a `Status: 0 sorries / 0 axioms` line, a `CLAUDE.md` playbook, a `PROGRESS.md`
  walkthrough, and a `scripts/sorries` gate.
- **`dln-dynamics-formalisation`** (this author's project, formalizing Saxe 2014)
  — source of the concrete tooling copied here: the `lean-lsp-mcp` inner loop,
  `scripts/no_sorry.sh`, and the CLAUDE.md sections on proof workflow / proof
  tactics / Mathlib API.

## Lineage

The two inspirations behind the project, mapped to what they actually contribute:

- **Geoffrey Irving** — a **ground-truth checker** (the Lean kernel; `lake build`
  and `#print axioms` are the arbiters, never the model) and **adversarial review**
  of correctness. Here that is the sorry/axiom gate plus `CRITICISMS.md` and the
  "verify statements against the primary source early" discipline — not an LLM
  debate pass, but the same stance: *trust the checker, attack your own claims*.
- **Dan Murfet** — **Lean 4 + Mathlib formalization** as the substrate and the
  habit of a clean, honest formal library with an explicit status of what is and
  isn't established.

## Why the structure is shaped this way

Two things catch two different failure modes:

1. **`lake build` + the sorry/axiom gate** catch *unproved / ill-typed* work.
   `#print axioms` must read `[propext, Classical.choice, Quot.sound]` — a stray
   `sorryAx` from a dependency is a real hole the text gate misses.
2. **Scope-honesty docs** (the README scope section, `PROGRESS.md`, `CRITICISMS.md`)
   catch *overclaiming* — a statement that compiles and is true but is a
   *derived side result* dressed up as the paper's main theorem. This is the
   failure unique to formalization, and it is handled socially (explicit prose),
   not mechanically.

The third failure mode — a faithful-looking statement that does **not** mean what
the paper means (misformalisation) — is caught not by a numerical/special-case
check but **socially**, at Stage 1: read the primary source, transcribe the
statement exactly, cite its label, and have a human sign off before proving.

Deliberately **omitted**: a `leanblueprint`. Blueprints earn their keep on large,
multi-contributor projects (FLT, PFR); for a single-paper, single-agent
formalization they are overhead. The `CLAUDE.md` "Scope" section + the README
table + `PROGRESS.md` plan carry the same information with less ceremony. Add a
blueprint only if the project grows enough collaborators to need the dependency
graph.

## The formalisation loop

The Stage-1/3/4 workflow (in the `auto-loop` / `auto-formalise` skills) is a plain
skeleton-first prove loop. There is **no evolutionary search** — no EVOLVE markers,
no searchable-value slots, no rater/Elo/population layer.

- **Proof skeleton** — the unit of work is a typechecking, `sorry`-bearing Lean file
  whose *frozen statement* is the declaration signature. Forcing the Stage-1 idea into a
  compiling skeleton is the filter that makes it "good enough to check in Lean". A genuinely
  unknown constant is an ordinary `def` the proof pins — not a slot to search.
- **Parallel prover fan-out (Ralph loops)** — Stage 3 may run N independent provers, each in
  its own worktree, each editing-and-compiling in episodes with `-- lessons:` carried forward;
  keep the first to reach validated green. This is plain parallelism (sampling), not an
  evolutionary algorithm — there is no reseed/generation loop.
- **Validator** — admission requires every frozen declaration *signature* be byte-identical to
  the baseline (difficulty not offloaded by mutating the target) *and* the library compile
  sorry/axiom-free. `scripts/validate`.
- **Prover-oracle with a disproof channel** — **Aristotle**, called on stuck subgoals (proof →
  substitute, disproof/failure → feed back), plus `codex` as the cheap informal counterexample
  tier.

The honesty failure modes map onto the gates: a helper that *morally restates the target* is
caught by `scripts/validate`'s statement-diff (mechanical) + the Stage-4 Aristotle audit
(semantic); a lemma falsely claimed "known in the literature" by end-to-end `#print axioms` +
the Mathlib-resolves check; and misformalisation by Stage-1 source-faithful transcription +
human sign-off (no numerical/special-case test-lemma gate). These are the same failure modes
`CRITICISMS.md` and the sorry/axiom gate already exist to catch.

## The artifacts, and what each is for

| File | Role |
|------|------|
| `CLAUDE.md` | The agent's memory: scope, conventions, **proof workflow**, accumulated **proof tactics**, a growing **Mathlib API** reference, house rules, the MCP/`lake` loop. The single most important file. |
| `README.md` | Human-facing: the *what-is-formalized* table, the `Status` line, the scope-honesty section, build commands. |
| `PROGRESS.md` | The narrative (newest first) + the phased plan with risk levels. The *story*; CLAUDE.md holds the *lessons*. |
| `CRITICISMS.md` | The standing list of honesty/quality risks — re-audited as phases land. |
| `sketches/` | Stage-1 proof skeletons: frozen statement + `:= by sorry` body. The unit of work the prover fills in; `<topic>.frozen.lean` is the validator baseline. |
| `scripts/no_sorry.sh` | The sorry/axiom gate. Local + CI. |
| `scripts/validate` | The validator gate: frozen declaration-signature diff + the sorry gate. |
| `.mcp.json` | `lean-lsp-mcp` — the sub-second inner loop. |

## What to change for your project

- Rename `Project` → your name (lakefile, `Project.lean`, `Project/`, the
  namespace, and `LIB` in `scripts/no_sorry.sh`).
- Fill every `<FILL IN>` in `CLAUDE.md`, `README.md`, `PROGRESS.md`,
  `CRITICISMS.md`, `Project/Basic.lean`.
- Commit the source PDF to `papers/`.
- Keep `CLAUDE.md`'s Proof tactics / Mathlib API sections **growing** — that
  accumulation is the point.
