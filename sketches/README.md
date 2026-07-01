# Sketches

The Stage-1 deliverable of the formalisation loop (see the `auto-loop` /
`auto-formalise` skills and [`docs/DESIGN.md`](../docs/DESIGN.md)). Each
`<topic>.lean` here is a **proof skeleton**: a *typechecking* Lean file with

- the **target theorem** stated to track the paper, body `:= by sorry` — the
  *frozen statement*;
- helper lemmas and the proof body, which the prover fills in.

There are **no EVOLVE markers** and no searchable `EVOLVE-VALUE` unknowns: the
statement is frozen, the proof body is free. If a constant is genuinely unknown,
state it as an ordinary `def` and let the proof pin it.

A skeleton must `lake build` (skeleton-correct, `sorry`-bearing) before Stage 1
closes: if it will not typecheck, the idea is underspecified.

## The frozen baseline

When the human approves the statement at the end of Stage 1, copy the skeleton to a
read-only baseline:

```sh
cp sketches/<topic>.lean sketches/<topic>.frozen.lean   # never edit again
```

The validator pins the working file against it — every frozen declaration
*signature* (keyword … up to `:=`) must stay byte-identical; proof bodies may
change freely:

```sh
scripts/validate sketches/<topic>.frozen.lean sketches/<topic>.lean
```

Sketches are working artefacts, not production: `scripts/no_sorry.sh` scopes the
sorry/axiom gate to the library dir, not here. See `example-sketch.lean`.
