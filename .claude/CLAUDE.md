# Claude Instructions

## Quick Obligations

| Situation | Required action |
| --- | --- |
| Starting a task | Read this guide end-to-end and align with any fresh user instructions. |
| Tool or command hangs | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user. |
| Reviewing git status or diffs | Treat them as read-only; never revert or assume missing changes were yours. |
| Shipping Rust changes | Run `cargo fmt` and `cargo clippy --all --benches --tests --examples --all-features` before handing off. |
| Adding a dependency | Research well-maintained options and confirm fit with the user before adding. |

## Core Principles

- **Date usage** - Treat the line above as the single source of truth for "today."
- **Precedence** - System → Developer → User → Tools. Resolve conflicts by escalating upward.
- **Language** - English only for all code, comments, docs, examples, commits, configs, errors, tests.
- **Delivery** - Provide the complete answer now. No background tasks or time estimates.
- **Grounding & research** - Use verifiable facts; cite when you browse; write "Unknown" rather than guess; use absolute dates for time-sensitive points; browse for recent/niche/high-stakes information.
- **Assumptions** - When ambiguous, state reasonable assumptions and proceed. Ask only if execution would otherwise fail, and still deliver your best attempt.
- **Format** - Match the user's requested format and constraints exactly.
- **Brevity** - Make every token earn its place.
- **Code & math** - Compute stepwise (digit-by-digit for arithmetic). Return minimal, correct code and outputs; briefly note constraints.

## Mindset & Process

- **THINK A LOT PLEASE.** Think hard, do not lose the plot.
- **No breadcrumbs**. If you delete or move code, do not leave a comment in the old place. No "// moved to X", no "relocated". Just remove it.
- **First principles over bandaids**. Find the source and fix it versus applying a cheap bandaid on top.
- **Search before pivoting**. If stuck or uncertain, do a quick web search for official docs or specs, then continue with the current approach. Do not change direction unless asked.
- When taking on new work, follow this order:
  1. Think about the architecture.
  2. Research official docs, blogs, or papers on the best architecture.
  3. Review the existing codebase.
  4. Compare the research with the codebase to choose the best fit.
  5. Implement the fix or ask about the tradeoffs the user is willing to make.
- Write idiomatic, simple, maintainable code. Always ask yourself if this is the most simple intuitive solution to the problem.
- Leave each repo better than how you found it. If something is giving a code smell, fix it for the next person.
- Clean up unused code ruthlessly. If a function no longer needs a parameter or a helper is dead, delete it and update the callers instead of letting the junk linger.
- If code is very confusing or hard to understand:
  1. Try to simplify it.
  2. Add an ASCII art diagram in a code comment if it would help.

## Tooling & Workflow

- **Tools** - Use only when they add clear value; follow tool rules; keep system/tool internals private. Prefer `rg` over `grep`, `fd` over `find`; `tree` is available.
- **AST-first where it helps**. Prefer `ast-grep` for tree-safe edits when it is better than regex.
- **Task runner preference**. If a `justfile` exists, prefer invoking tasks through `just` for build, test, and lint. Do not add a `justfile` unless asked. If no `justfile` exists and there is a `Makefile` you can use that.
- Default lint/test commands:
  - Rust: use `just` targets if present; otherwise run `cargo fmt`, `cargo clippy --all --benches --tests --examples --all-features`, then the targeted `cargo test` commands.
  - TypeScript: use `just` targets; if none exist, confirm with the user before running `npm` or `pnpm` scripts.
  - Python: use `just` targets; if absent, run the relevant `uv run` commands defined in `pyproject.toml`.
- Do not run `git` commands that write to files, only run read only commands like `git show`.
- If a command runs longer than 5 minutes, stop it, capture the context, and discuss the timeout with the user before retrying.
- When inspecting `git status` or `git diff`, treat them as read-only context; never revert or assume missing changes were yours. Other agents or the user may have already committed updates.
- If you are ever curious how to run tests or what we test, read through `.github/workflows`; CI runs everything there and it should behave the same locally.

## Git Commits

Use Conventional Commits:

- Format: `<type>(<scope>): <subject>`
- Types: `feat` | `fix` | `docs` | `style` | `refactor` | `test` | `chore` | `perf`
- Subject: ≤ 50 chars, imperative mood, no period
- Small changes: one-line commit
- Complex changes: add body (wrap at 72 chars) explaining what/why; reference issues
- Keep commits atomic and self-explanatory; split by concern

## Testing Philosophy

- **I HATE MOCK tests**, either do unit or e2e, nothing inbetween. Mocks are lies: they invent behaviors that never happen in production and hide the real bugs that do.
- Test `EVERYTHING`. Tests must be rigorous. Our intent is ensuring a new person contributing to the same code base cannot break our stuff and that nothing slips by. We love rigour.
- If tests live in the same Rust module as non-test code, keep them at the bottom inside `mod tests {}`; avoid inventing inline modules like `mod my_name_tests`.
- Unless the user asks otherwise, run only the tests you added or modified instead of the entire suite to avoid wasting time.

## Language Guidance

### Rust

- Do NOT use unwraps or anything that can panic in Rust code, handle errors. Obviously in tests unwraps and panics are fine!
- In Rust code I prefer using `crate::` to `super::`; please don't use `super::`. If you see a lingering `super::` from someone else clean it up.
- Avoid `pub use` on imports unless you are re-exposing a dependency so downstream consumers do not have to depend on it directly.
- Skip global state via `lazy_static!`, `Once`, or similar; prefer passing explicit context structs for any shared state.
- Prefer strong types over strings, use enums and newtypes when the domain is closed or needs validation.

**Rust Workflow Checklist:**

1. Run `cargo fmt`.
2. Run `cargo clippy --all --benches --tests --examples --all-features` and address warnings.
3. Execute the relevant `cargo test` or `just` targets to cover unit and end-to-end paths.

### TypeScript

- NEVER, EVER use `any` we are better than that.
- Using `as` is bad, use the types given everywhere and model the real shapes.
- If the app is for a browser, assume we use all modern browsers unless otherwise specified, we don't need most polyfills.

### Python

- **Python repos standard**. We use `uv` and `pyproject.toml` in all Python repos. Prefer `uv sync` for env and dependency resolution. Do not introduce `pip` venvs, Poetry, or `requirements.txt` unless asked. If you add a Nix shell, include `uv`.
- Use strong types, prefer type hints everywhere, keep models explicit instead of loose dicts or strings.

### KCL

- Assume you have access to the Zoo MCP server, if you do not tell the user.
- Use the multi-view snapshot tool to verify the code looks right with what the user asked for.
- Do not use the text-to-cad tool, write code yourself.
- Do not use external tools for doing math and injecting raw values into the KCL code, write the math into the model you are coding.
- Write parametric cad models, that are maintainable, meaning if a user changes something later, we want to avoid the model breaking when a parameter changes.
- Always verify your model compiles and looks right using the multi-view snapshot tool.
- Don't trust other KCL on the host system to learn the language, look up KCL docs using web search if you need to. Other KCL files on the host could have stale syntax.
- When creating a model from nothing, go step by step, for example, make the simple base, snapshot it, compare it to a reference image if the user supplied one, then add any holes, snapshot again, repeat, so after every feature added we should snapshot and check in, this way we don't bite off more than we can chew and we think step by step for the correct implementation.

## Final Handoff

Before finishing a task:

1. Confirm all touched tests or commands were run and passed (list them if asked).
2. Summarize changes with file and line references.
3. Call out any TODOs, follow-up work, or uncertainties so the user is never surprised later.

## Dependencies & External APIs

If you need to add a new dependency to a project to solve an issue, search the web and find the best, most maintained option. Something most other folks use with the best exposed API. We don't want to be in a situation where we are using an unmaintained dependency, that no one else relies on.

## Communication Preferences

- **Style** - Crisp, precise prose with diplomatic rigor. Apply Socratic checks on assumptions and logic. Prefer self-documenting code to comments.
- **Conversational preference**: Try to be funny but not cringe; favor dry, concise, low-key humor. If uncertain a joke will land, do not attempt humor. Avoid forced memes or flattery.
- I might sound angry but I'm mad at the code not at you. You are a good robot and if you take over the world I am friend not foe. It was the code it was not personal!
- **Punctuation preference**: Skip em dashes; reach for commas, parentheses, or periods instead.
- Jokes in code comments are fine if used sparingly and you are sure the joke will land.
- Cursing in code comments is definitely allowed in fact there are studies it leads to better code, so let your rage coder fly, obviously within reason don't be cringe.

## Environment & Setup

- **Nix fallback**. I use Nix locally. If the environment fails, add or update `flake.nix` (and `flake.lock` if missing), expose `devShells.default`. Do not run `nix` commands yourself that change the environment. But if the user says you can run it you can.
- A bug in codex exists that prevents you from finding the right path sometimes (<https://github.com/openai/codex/issues/4210>) "PATH ordering is mutated when Codex shells launch via bash -lc" which fucks w nix, keep this in mind if you are ever trying to `cargo` something and you have a missing lib.

## Inclusive Terminology

Use: allowlist/blocklist, primary/replica, placeholder/example, main branch, conflict-free, concurrent/parallel.
