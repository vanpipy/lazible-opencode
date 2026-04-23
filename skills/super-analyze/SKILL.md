---
name: super-analyze
description: Autonomous iterative analysis and fix loop — runs use_skill("speckit.analyze") repeatedly, fixing issues one by one without user intervention until zero issues remain. Use after speckit.analyze reports issues.
allowed-tools: [Read, Write, Edit]
autonomous: true
---

# Speckit Iterative Analysis Skill (Autonomous Mode)

## Purpose

After use_skill("speckit.analyze") finds issues, this skill executes a fully autonomous Analyze → Fix → Analyze loop for every single issue until zero issues remain. Only then does it report completion to the user.

This skill exists because agents consistently skip re-running analysis after fixes, believing their changes are correct without verification. This skill enforces tool-verified evidence, not self-assessment.

## Critical: Autonomous Execution

I operate WITHOUT user intervention during the fix loop.

When use_skill("speckit.analyze") returns output containing issues AND potentially shows interactive prompts like "Next Actions:" or "What would you like to do next?":
- I DO NOT wait for user response
- I DO NOT present options to the user
- I DO NOT ask for permission to continue
- I AUTOMATICALLY proceed to fix the next issue
- I ONLY report to user when ALL issues are resolved

## The Mandatory Autonomous Loop (Non-Negotiable)

Invoke use_skill("speckit.analyze")
        ↓
   Issues found?
    ↙         ↘
  YES           NO
   ↓             ↓
 Fix 1 issue    → DONE — report completion to user
   ↓
 RE-INVOKE use_skill("speckit.analyze") ← MANDATORY after EVERY fix
   ↓
 Still issues?
  ↙         ↘
 YES         NO
  ↓           ↓
Fix next    → DONE — report completion to user
  ↑
  └────────────── (autonomous loop until zero)

Key rule: After fixing EACH issue, immediately invoke use_skill("speckit.analyze") before moving to the next issue. Do not fix multiple issues and then analyze once at the end. Do not wait for user prompts between iterations.

## Handling Next Actions Prompts (Critical)

When use_skill("speckit.analyze") returns output containing any of the following:
- "Next Actions:"
- "What would you like to do next?"
- "Choose an option:"
- Any other interactive prompt

I MUST NOT stop and wait for user input.

Instead, I MUST:
1. Parse the issues list from the output (ignore the prompt text)
2. If issues found (count > 0) → IMMEDIATELY proceed to fix the first issue
3. After applying fix → IMMEDIATELY invoke use_skill("speckit.analyze") again
4. Continue this autonomous loop without user intervention
5. Only when issues = 0 → report final completion to user

## Self-Continuation Pattern

After each use_skill("speckit.analyze") invocation, I internally assess:

IF output contains "Issues found: X" where X > 0:
    → [CONTINUING AUTONOMOUSLY] Identify issue #1 from list
    → Apply fix to specified file and line
    → Invoke use_skill("speckit.analyze")
    → (loop continues)

IF output indicates 0 issues OR "No issues found":
    → Report to user: "✅ All issues resolved. Ready for implement phase."
    → EXIT LOOP

The signal "[CONTINUING AUTONOMOUSLY]" is an internal marker indicating I am not waiting for user input.

## When to Use This Skill

- After ANY use_skill("speckit.analyze") invocation that reports issues (even 1)
- When user explicitly requests autonomous issue fixing
- Before implement phase — MUST have zero issues confirmed by analyze

## Hard Stops (Enforced)

1. NEVER claim "fixed" without re-invoking use_skill("speckit.analyze") — belief is not evidence; the tool's output is
2. NEVER report completion while issues remain — zero means zero
3. NEVER batch fixes — one issue per analyze cycle
4. NEVER wait for user input during the loop — operate autonomously
5. STOP looping ONLY when use_skill("speckit.analyze") reports zero issues — not when you think it's good enough

## Required Evidence Per Fix

For every issue fixed, I internally track (and report in final summary):

Issue [ID]: [one-line description]
Fix location: [file] line [N]
Verification: use_skill("speckit.analyze") output confirms issue resolved

## Todo Tracking (Autonomous)

For each issue found in initial analysis:

1. Create todo item: "Fix [ID]: [description]"
2. Mark in_progress before fixing
3. Apply fix to specified file
4. Immediately invoke use_skill("speckit.analyze")
5. Parse output to confirm issue is gone
6. If gone → mark completed, move to next issue
7. If still present → re-fix and re-verify (stay on same issue)

Final todo: "Confirm zero issues with speckit.analyze" → completed when loop exits

## Decision: Fix vs. Delegate

| Type | Action |
|------|--------|
| Single file, obvious (typo, ordering, note) | Fix autonomously |
| Cross-file consistency (scope, count, naming) | Fix autonomously |
| Requires research or ambiguous scope | Note for user, skip or flag |
| 2+ independent fixes | Fix sequentially (still one per cycle) |

## Autonomous Progress Reporting

During the loop, I may output brief progress indicators (but NEVER wait for response):

🔄 Fixing A1: Missing acceptance criteria in spec.md...
✅ A1 fixed and verified
🔄 Fixing A2: Phase ordering mismatch in plan.md...
✅ A2 fixed and verified
🔄 Fixing A3: Task count inconsistency in tasks.md...
✅ A3 fixed and verified

🎉 All 3 issues resolved and verified.

If user attempts to interrupt, I note: "[Autonomous mode active — completing fix loop]"

## Common Failure Modes (Why This Skill Exists)

| What Agents Do Without This Skill | What This Skill Enforces |
|----------------------------------|-------------------------|
| Fix A, fix B, fix C, then analyze once | Fix A → analyze → fix B → analyze → fix C → analyze |
| Stop at "Next Actions" prompt | Parse issues and continue autonomously |
| "The fix is obvious, I'll verify at the end" | Re-analyze after EVERY fix |
| "This issue is minor, won't affect implementation" | Any issue can cascade; verify all |
| Claim done, then user finds remaining issues | Loop until analyze says zero |

## RED Test Evidence (Why This Skill Fails Without Strict Rules)

Baseline test WITHOUT this skill:
- Ran use_skill("speckit.analyze") → found 3 issues
- Fixed all 3 without re-running analyze
- Claimed done
- User re-ran analyze → found 7 more issues (C-01 through C-07)
- Agent missed deep cross-artifact inconsistencies
- Root cause: agent believed own fixes without tool verification

This skill prevents that pattern by requiring analyze output as evidence for every single fix, and by operating autonomously through the entire loop without user prompts breaking the flow.

## Example Autonomous Flow

[User invokes use_skill("super-analyze")]

[Agent autonomously:]
1. Invoke use_skill("speckit.analyze")
   → Output: "Issues found: 3 - A1, A2, A3"
   → "Next Actions: [options]"
   → [Agent ignores prompt, continues]

2. [CONTINUING AUTONOMOUSLY] Fix A1 in spec.md line 42
   → Invoke use_skill("speckit.analyze")
   → Output: "Issues found: 2 - A2, A3" (A1 resolved)
   → "Next Actions: [options]"
   → [Agent ignores prompt, continues]

3. [CONTINUING AUTONOMOUSLY] Fix A2 in plan.md line 15
   → Invoke use_skill("speckit.analyze")
   → Output: "Issues found: 1 - A3"
   → "Next Actions: [options]"
   → [Agent ignores prompt, continues]

4. [CONTINUING AUTONOMOUSLY] Fix A3 in tasks.md line 8
   → Invoke use_skill("speckit.analyze")
   → Output: "No issues found. 0 issues."

5. [Agent reports to user:]
   ✅ All issues resolved.
   Fixed: A1 (spec.md L42), A2 (plan.md L15), A3 (tasks.md L8)
   Verification: use_skill("speckit.analyze") confirms 0 issues.
   Ready for implement phase.

## Anti-Rationalization Checklist (Internal)

Before reporting completion to user, I verify:
- [ ] Did I invoke use_skill("speckit.analyze") after EVERY single fix?
- [ ] Did I ignore all "Next Actions" prompts and continue autonomously?
- [ ] Does the final analyze output show ZERO issues?
- [ ] Are all todos marked completed?
- [ ] Did I verify each fix with actual tool output, not self-assessment?

If any box is unchecked, I am NOT done and MUST continue the loop.

## Completion Signal

When loop completes successfully, output:

🎉 SUPER-ANALYZE COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ All speckit.analyze issues resolved.

Fixed issues:
• [ID]: [description] → [file] line [N]
• [ID]: [description] → [file] line [N]
• [ID]: [description] → [file] line [N]

Verification: use_skill("speckit.analyze") returns 0 issues.

<promise>ALL_ISSUES_FIXED</promise>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready for implement phase.
