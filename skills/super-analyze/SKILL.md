---
name: super-analyze
description: Use after /speckit.analyze reports issues — enforces mandatory analyze-verify loop until zero issues before /speckit.implement. NOT for trivial fixes alone.
---

# Speckit Iterative Analysis Skill

## Purpose

After `/speckit.analyze` finds issues, **iterate** Analyze → Fix → Analyze **for every single issue** until the tool reports zero issues. Only then hand off to `/speckit.implement`.

This skill exists because agents consistently skip re-running analysis after fixes, believing their changes are correct without verification. They don't.

## The Mandatory Loop (Non-Negotiable)

```
Run /speckit.analyze
        ↓
   Issues found?
    ↙         ↘
  YES           NO
   ↓             ↓
 Fix 1      → DONE — hand off to /speckit.implement
   ↓
 RE-RUN analyze ← MANDATORY after EVERY fix
   ↓
 Still issues?
  ↙         ↘
 YES         NO
  ↓           ↓
Fix 2    → DONE
  ↑
  └────────────── (loop until zero)
```

**Key rule: After fixing EACH issue, re-run `/speckit.analyze` before moving to the next issue.** Do not fix multiple issues and then run analyze once at the end.

## When to Use

- After ANY `/speckit.analyze` run that reports issues (even 1)
- After ANY fix applied to spec.md, plan.md, or tasks.md
- Before `/speckit.implement` — MUST have zero issues confirmed by analyze output

## Hard Stops (Enforced)

1. **NEVER claim "fixed" without re-running `/speckit.analyze`** — your belief that a fix is correct is not evidence; the tool's output is
2. **NEVER hand off to `/speckit.implement` while issues remain** — zero means zero
3. **NEVER skip to "verifying all at once"** — one issue per analyze cycle
4. **STOP looping ONLY when `/speckit.analyze` reports zero issues** — not when you think it's good enough

## Required Evidence Per Fix

For every issue fixed, you MUST show:

```
Issue [ID]: [one-line description]
Fix: [file] line [N]
Verification: /speckit.analyze output showing this issue no longer appears
```

**If you cannot show analyze output confirming the fix, the fix is NOT complete.**

## Todo Tracking

For each issue found:

1. Create todo item: "Fix [ID]: [description]"
2. Mark `in_progress` before fixing
3. Fix the issue
4. **Immediately re-run `/speckit.analyze`**
5. Confirm issue is gone in output
6. Mark `completed`
7. Move to next issue (if any)

Final todo: "Run /speckit.analyze — confirm zero issues"

## Decision: Fix vs. Delegate

| Type | Action |
|------|--------|
| Single file, obvious (typo, ordering, note) | Fix myself |
| Cross-file consistency (scope, count, naming) | Fix myself |
| Requires research or ambiguous scope | Delegate to subagent |
| 2+ independent fixes | Parallel subagents |

## Common Failure Modes (Why This Skill Exists)

| What Agents Do | What They Should Do |
|----------------|-------------------|
| Fix A, fix B, fix C, *then* run analyze once | Fix A → analyze → fix B → analyze → fix C → analyze |
| "The fix is obvious, I'll verify at the end" | Re-run analyze after EVERY fix |
| "This issue is minor, won't affect implementation" | Any issue can cascade; verify or document |
| "I understand the codebase now, no need to re-check" | The analyze tool found it; trust the tool |
| Claim done, then user finds remaining issues | Loop until analyze says zero, not until you feel done |

## RED Test Evidence (Why This Skill Fails Without Strict Rules)

Baseline test WITHOUT this skill:
- Ran `/speckit.analyze` → found 3 issues
- Fixed all 3 without re-running analyze
- Claimed done
- Re-ran analyze → found 7 more issues (C-01 through C-07)
- Agent missed deep cross-artifact inconsistencies (Phase 1 ordering, coverage scope, missing task in decomposition)
- Root cause: agent believed its own fixes without tool verification

This skill prevents that pattern by requiring analyze output as evidence, not self-assessment.

## Example Correct Flow

```
Round 1:
> /speckit.analyze → 3 issues: A1, A2, A3

Fix A1:
> /speckit.analyze → still shows A1? No → A1 confirmed fixed
> Create todo "Fix A1" → in_progress → completed

Fix A2:
> /speckit.analyze → still shows A2? No → A2 confirmed fixed
> Create todo "Fix A2" → in_progress → completed

Fix A3:
> /speckit.analyze → ZERO issues
> Create todo "Fix A3" → in_progress → completed
> Create todo "Final verify" → completed

Hand off to /speckit.implement
```

## Anti-Rationalization Checklist

Before claiming done, ask yourself:
- [ ] Did I re-run `/speckit.analyze` after EVERY fix?
- [ ] Did I show the analyze output proving each issue is gone?
- [ ] Does the final analyze show ZERO issues?
- [ ] Are all todos marked completed with evidence?
- [ ] Am I confident, or do I just want to move on?

If any box is unchecked, **you are not done**.
