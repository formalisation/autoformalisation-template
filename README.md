# <PROJECT>

A Lean 4 + [Mathlib](https://github.com/leanprover-community/mathlib4)
formalization of <FILL IN: the result(s)>, following

> <FILL IN: Author(s). *Title*. Venue, year. arXiv:XXXX.XXXXX>

The compiled paper is included as [`papers/<source>.pdf`](papers/).

> This is a template for **LLM-assisted, interactive Lean formalization** of a
> specific paper (Claude Code + `lean-lsp-mcp` as the inner loop; skeleton-first
> with a frozen statement, fan-out prover subagents gated by a validator +
> sorry/axiom gate, and scope-honesty discipline). It is
> modelled on [`girving/aks`](https://github.com/girving/aks),
> [`timaeus-research/laplace`](https://github.com/timaeus-research/laplace), and
> `dln-dynamics-formalisation`. Lineage and design rationale: [`docs/DESIGN.md`](docs/DESIGN.md).
> Replace every `<FILL IN>` / `<PROJECT>` and delete this blockquote.

## What is formalized

<FILL IN: the headline "what's proved" table — the convention every reference
repo uses. Map each result to its source reference and its Lean name.>

| Result | Statement | Source ref | Lean |
| --- | --- | --- | --- |
| <name> | `<informal statement>` | Eq. `<label>` | `<Decl>` |

**Status.** <FILL IN: lines, #theorems> · **0 sorries, 0 axioms, 0 `native_decide`**
(`bash scripts/no_sorry.sh`; every capstone's `#print axioms` is
`[propext, Classical.choice, Quot.sound]`).

**Scope / honesty.** <FILL IN: state plainly what is established vs. what is NOT
yet formalized, and flag any result that is a *derived side result* rather than
the paper's full argument. This section is load-bearing — do not let the Lean
appear to prove more than it does.> Deferred work is tracked in
[`PROGRESS.md`](PROGRESS.md); open quality concerns in [`CRITICISMS.md`](CRITICISMS.md).

## Build

```sh
lake exe cache get   # download prebuilt Mathlib oleans (once)
lake build
```

Check there are no proof gaps:

```sh
bash scripts/no_sorry.sh           # sorry / admit / native_decide / axiom gate
scripts/validate sketches/<topic>.frozen.lean sketches/<topic>.lean   # frozen-stmt + sorry gate
```

## Layout

```
<PROJECT>.lean              root, imports the modules below
<PROJECT>/Basic.lean        core definitions + headline statement
<PROJECT>/...               one module per topic (cite source labels in docstrings)
sketches/                   Stage-1 proof skeletons (frozen stmt + `:= by sorry` body)
papers/                     the primary source (PDF) + lit notes
scripts/no_sorry.sh         sorry / axiom gate (also run in CI)
scripts/validate            validator gate: frozen declaration-signature diff + sorry gate
CLAUDE.md                   project memory: workflow, proof tactics, Mathlib API
PROGRESS.md                 narrative log (newest first) + phased plan
CRITICISMS.md               honesty / quality criticisms
formalization.yaml          mathlib-initiative metadata (v0.3); mirror of the "what's proved" table
.mcp.json                   lean-lsp-mcp (the fast inner loop)
```

On scaffold, fill in `formalization.yaml` (replace every `<FILL IN>`) and keep it
in sync with the "What is formalized" table above — the `auto-loop` close stage
updates it each cycle. Mathlib naming/style/tactic conventions live once in
[`../.claude/skills/lean-references/`](../.claude/skills/lean-references/README.md); cite that path
rather than copying it here.
