---
name: superdev
description: Universal application development workflow - a standardized process from architecture design to implementation
---

# SuperDev - Universal Application Development Workflow

## Overview

This skill provides a standardized application development workflow applicable to a wide range of development scenarios.

**Core Principles:**
- Requirements-driven development
- Small, incremental commits
- Quality built into the process
- Documentation kept in sync with code

## Workflow Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│  Phase 0: Pre-flight Checks                                       │
│  Check speckit → Assess DESIGN.md health → Create branch         │
├──────────────────────────────────────────────────────────────────┤
│  Phase 1: Architecture Design                                     │
│  Create/update DESIGN.md → Technical specification docs          │
├──────────────────────────────────────────────────────────────────┤
│  Phase 2: Requirements Analysis                                   │
│  speckit workflow  OR  manual SPEC.md creation                   │
├──────────────────────────────────────────────────────────────────┤
│  Phase 3: Implementation Planning                                 │
│  Create PLAN.md + TASKS.md → Task breakdown                      │
├──────────────────────────────────────────────────────────────────┤
│  Phase 4: Incremental Development                                 │
│  Dispatch via task tool → Code review → Test → Commit            │
├──────────────────────────────────────────────────────────────────┤
│  Phase 5: Validation & Wrap-up                                    │
│  Verify → Code review → PR/MR → Merge                            │
└──────────────────────────────────────────────────────────────────┘
```

## Phase 0: Pre-flight Checks ⚠️ Critical Step

**Before starting, you MUST run this checklist:**

```markdown
## Pre-flight Checklist

### 1. Check whether speckit is available

Run the following command to check if the speckit tool exists:

```
/speckit.specify --help
```

### 2. Evaluate the result

| Result | Execution Path |
|--------|---------------|
| speckit available | Use the **speckit workflow** (Phase 2A) |
| speckit unavailable | Use the **manual workflow** (Phase 2B) |

### 3. If speckit is unavailable

```
╔════════════════════════════════════════════════════════════════╗
║  ⚠️  speckit tool not found                                     ║
║                                                                ║
║  The current environment does not support the speckit command. ║
║  Please use the manual workflow instead:                       ║
║                                                                ║
║  How to continue:                                              ║
║  1. Manually create docs/SPEC.md (see Phase 2B template)       ║
║  2. Proceed to Phase 3 Implementation Planning                 ║
║                                                                ║
║  To enable the speckit workflow, install the speckit plugin.   ║
╚════════════════════════════════════════════════════════════════╝
```

### 4. DESIGN.md Health Check ⚠️

If `docs/DESIGN.md` or `DESIGN.md` already exists, you MUST assess its health:

#### 4.1 Read DESIGN.md

```bash
# Locate the DESIGN.md file
find . -name "DESIGN.md" -o -name "docs/DESIGN.md" 2>/dev/null

# Read its contents
cat docs/DESIGN.md
```

#### 4.2 Health Assessment Criteria

| Criterion | Weight | What to Check | Scoring |
|-----------|--------|---------------|---------|
| Completeness | 20% | Contains all 6 required sections | -33% per missing section |
| Tech Stack Clarity | 15% | Language, framework, dependencies are explicit | -5% per missing item |
| System Architecture | 20% | Module breakdown, dependency graph | -20% if vague or missing |
| Data Model | 15% | Core entities defined | -5% per missing entity |
| API Design | 15% | Endpoint list, request/response format | -15% if vague or missing |
| Deployment Architecture | 15% | Deployment mode, environment config | -15% if vague or missing |

#### 4.3 Calculate Health Score

```
Health Score = (Completeness + Tech Stack + Architecture + Data Model + API + Deployment) × 100%
```

#### 4.4 Evaluate the Result

| Health Score | Status | Action |
|-------------|--------|--------|
| ≥ 80% | ✅ Excellent | Proceed |
| 60% – 79% | ⚠️ Acceptable | Recommended to improve before proceeding |
| < 60% | ❌ Failing | **Must improve before continuing** |

#### 4.5 If Health Score < 60%

```
╔════════════════════════════════════════════════════════════════════════╗
║  ❌ DESIGN.md health check failed                                      ║
║                                                                        ║
║  Current score: {X}% (minimum required: 60%)                          ║
║                                                                        ║
║  Missing / incomplete items:                                           ║
║  - [specific missing item 1]                                           ║
║  - [specific missing item 2]                                           ║
║                                                                        ║
║  Recommended actions:                                                  ║
║  1. Fill in the missing sections listed above                          ║
║  2. Use the Phase 1 DESIGN.md template as a reference                  ║
║  3. Re-run the Phase 0 health check                                    ║
║                                                                        ║
║  Workflow is paused. Please improve DESIGN.md and restart.             ║
╚════════════════════════════════════════════════════════════════════════╝
```

### 5. Create a Branch

Regardless of which path you take, create a development branch first:

```bash
# Create a feature branch
git checkout -b feature/{project-name}

# Or, for a brand-new project
git init
git checkout -b main
```

## Entry Points

**When to use this skill:**
- Building a new application from scratch
- Refactoring or rebuilding an existing application
- Adding a significant new feature
- Collaborating on a team project

**Steps:**
1. Run the Phase 0 pre-flight checks
2. Choose the Phase 2 execution path based on the results
3. Execute Phases 1–5 in order

## Phase 1: Architecture Design

### Goal
Create `DESIGN.md` to define the project's technical architecture and high-level design.

### Steps

1. **Create `docs/DESIGN.md`** (or `DESIGN.md` in the project root)

```markdown
# Project Name - Technical Architecture Document

## 1. Project Overview
- Project background and objectives
- Core value proposition
- Target users / use cases

## 2. Tech Stack
- Programming language and version
- Frameworks and key dependencies
- Database / storage solution
- Other infrastructure

## 3. System Architecture
- Overall architecture diagram (text description)
- Module breakdown
- Inter-module dependency relationships

## 4. Data Model
- Core entity definitions
- Entity relationships
- Data flow

## 5. API Design
- API style (REST / GraphQL / gRPC)
- Core endpoint list
- Request / response format

## 6. Deployment Architecture
- Deployment mode
- Environment configuration
```

### Acceptance Criteria
- [ ] DESIGN.md contains all 6 sections above
- [ ] Technology choices include clear rationale
- [ ] Module boundaries are clear with explicit dependency relationships

## Phase 2: Requirements Analysis

Based on the Phase 0 results, choose one of the following execution paths:

---

### Phase 2A: Speckit Workflow (when speckit is available)

#### Step 1: Specify – Create a functional specification

```bash
/speckit.specify
```

Or manually create `docs/SPEC.md`:

```markdown
# Functional Specification

## 1. User Stories / Use Cases
- US1: [User story description]
- US2: [User story description]

## 2. Feature Details
### US1: [Name]
- Description: [Feature description]
- Acceptance Criteria:
  - AC1: [Specific, verifiable criterion]
  - AC2: [Specific, verifiable criterion]
- Edge Cases: [Error / boundary condition handling]

### US2: [Name]
- ...

## 3. Non-Functional Requirements
- Performance: [Specific metrics]
- Security: [Authentication / authorization requirements]
- Availability: [SLA targets]

## 4. Dependency Analysis
- External dependencies: [Third-party services / libraries]
- Internal module dependencies: [Inter-module dependencies]
```

#### Step 2: Clarify – Requirements clarification

```bash
/speckit.clarify
```

Clarify 4 key questions:
1. **Scope boundary**: What is in scope? What is explicitly out of scope?
2. **Technical constraints**: What limitations exist?
3. **Acceptance criteria**: How do we know when a feature is done?
4. **Risk areas**: What are the biggest uncertainties?

#### Step 3: Plan – Generate an implementation plan

```bash
/speckit.plan
```

Outputs:
- `PLAN.md` – Phased implementation plan
- `DATA_MODEL.md` – Data model design
- `contracts/` – Interface contracts

#### Step 4: Tasks – Task breakdown

```bash
/speckit.tasks
```

Outputs `TASKS.md`:
- Tasks organized by phase / module
- Each task includes: ID, name, description, acceptance criteria
- Inter-task dependencies are marked

#### Step 5: Analyze – Analysis and validation

```bash
/speckit.analyze
```

Validates:
- Specification completeness
- Plan feasibility
- Risk assessment
- Resource estimation

---

### Phase 2B: Manual Workflow (when speckit is unavailable)

When speckit is not available, follow these steps manually:

#### Step 1: Create SPEC.md

Use the SPEC.md template from Phase 2A to create `docs/SPEC.md`.

#### Step 2: Requirements Clarification

Manually answer the 4 clarification questions (write them into SPEC.md or a separate document):

```markdown
## Requirements Clarification

### Q1: Scope Boundary
- [Features explicitly in scope]
- [Features explicitly out of scope]

### Q2: Technical Constraints
- [Constraint 1]
- [Constraint 2]

### Q3: Acceptance Criteria
- [How to determine completion]

### Q4: Risk Areas
- [Primary uncertainties]
```

#### Step 3: Create PLAN.md

Use the PLAN.md template from Phase 3 to create `docs/PLAN.md`.

#### Step 4: Create TASKS.md

Use the TASKS.md template from Phase 3 to create `docs/TASKS.md`.

#### Step 5: Self-Check

Manually verify:
- [ ] Every user story in SPEC.md has acceptance criteria
- [ ] All 4 clarification questions are answered
- [ ] PLAN.md has complete phase breakdown
- [ ] TASKS.md covers all features

---

## Phase 3: Implementation Planning

### Goal
Create `PLAN.md` and `TASKS.md` to translate specifications into executable tasks.

### Steps

1. **Create / update `PLAN.md`**

```markdown
# Implementation Plan

## Phase Breakdown

### Phase A: [Phase Name]
- **Goal**: [Deliverable for this phase]
- **Task Range**: T001 – T005
- **Acceptance Criteria**: [How to determine phase completion]

### Phase B: [Phase Name]
- **Goal**: ...
- **Task Range**: T006 – T010
- **Acceptance Criteria**: ...

## Key Technical Decisions
| Decision | Choice | Rationale |
|----------|--------|-----------|
| [e.g. Database] | [e.g. PostgreSQL] | [Reason] |

## Risks and Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk description] | [Severity] | [Response] |
```

2. **Create / update `TASKS.md`**

```markdown
# Task List

## Phase A: [Phase Name]

| ID | Task | Acceptance Criteria | Status | Dependencies |
|----|------|---------------------|--------|--------------|
| T001 | [Task name] | [Criterion 1], [Criterion 2] | pending | - |
| T002 | [Task name] | [Criterion 1] | pending | T001 |
| T003 | [Task name] | [Criterion 1] | pending | T001, T002 |
```

### Task Decomposition Principles
- Each task should be completable in 1–4 hours
- Every task must have clear acceptance criteria
- Mark dependency relationships (which tasks must be completed first)

### Acceptance Criteria
- [ ] PLAN.md contains all phase breakdowns
- [ ] TASKS.md covers all user stories
- [ ] Every task has acceptance criteria
- [ ] Dependency relationships are correctly marked

## Phase 4: Incremental Development

### Goal
Execute tasks from TASKS.md, committing one small, complete change at a time.

### Phase 4 Entry Checklist

Before starting, ensure:
- [ ] TASKS.md has been created
- [ ] Development branch has been created and checked out
- [ ] Tasks are sorted by dependency order

### Execution Flow

```
for each task in TASKS.md (in dependency order):
    1. Mark task as in_progress
    2. Dispatch subagent using the task tool
    3. Wait for task completion
    4. Verify results
    5. Commit code
    6. Mark task as completed
    7. Handle errors (if any)
```

### Dispatching Subagents

#### Using the task tool

```
task(category="deep", load_skills=["superpowers/subagent-driven-development"], prompt="...")
```

**Parameter notes:**
- `category="deep"` – Use the deep execution category
- `load_skills=["superpowers/subagent-driven-development"]` – Load the subagent development skill
- `prompt="..."` – Task description (see template below)

**Full prompt template:**

```markdown
## CONTEXT
- Branch: {branch_name}
- Working directory: {workspace}
- Current task: {task_id} - {task_name}

## GOAL
{task_description}

## EXPECTED OUTCOME
- [Deliverable 1]
- [Deliverable 2]

## REQUIREMENTS (from TASKS.md)
- {requirement_1}
- {requirement_2}

## MUST DO
- Implement in {language}
- Follow the existing code style (reference: {pattern_file})
- Include unit tests
- Run lsp_diagnostics to verify after completion

## MUST NOT
- Do not modify unrelated files
- Do not introduce breaking changes
- Do not use `as any` or `@ts-ignore`

## EXISTING PATTERNS
Refer to the following files for code style:
- {file_1}
- {file_2}

## VERIFICATION
After implementation, you must verify:
1. lsp_diagnostics reports no errors
2. Relevant tests pass
3. All MUST DO / MUST NOT requirements are satisfied
```

#### Dispatch Example

```bash
# Single task dispatch
task(category="deep", load_skills=["superpowers/subagent-driven-development"], prompt="## CONTEXT\n- Branch: feature/myproject\n- Working directory: /path/to/project\n- Current task: T001 - Initialize project structure\n\n## GOAL\nInitialize the base project structure, including:\n- Create src/ directory structure\n- Create tests/ directory structure\n- Create base configuration files\n\n## EXPECTED OUTCOME\n- src/ directory contains standard structure\n- tests/ directory contains test structure\n- package.json contains base dependencies\n\n## MUST DO\n- Use TypeScript\n- Follow project style\n- Include base type definitions\n\n## MUST NOT\n- Do not add business logic\n- Do not modify existing files", run_in_background=false)
```

### Post-Task Verification

After implementation, you must verify:

1. **Functional Verification**
   - [ ] Meets requirements in SPEC.md
   - [ ] Meets acceptance criteria in TASKS.md

2. **Code Quality**
   - [ ] lsp_diagnostics reports no errors
   - [ ] Tests pass
   - [ ] Type check passes (if applicable)
   - [ ] All MUST DO / MUST NOT requirements are satisfied

3. **Commit**
   - [ ] Changes have been `git add`-ed
   - [ ] Commit message is clear (format: `T{task_id}: {short description}`)
   - [ ] `git commit` succeeded

### Error Handling

| Situation | Error Code | How to Handle |
|-----------|------------|---------------|
| Task failed | E001 | Analyze cause → Fix → Retry (max 2 retries) |
| Dependency blocked | E002 | Verify dependency is satisfied → Skip or parallelize |
| Scope creep | E003 | Log new requirement → Assess → Decide to include or create new task |
| Subagent timeout | E004 | Increase timeout or reduce task granularity |
| Verification failed | E005 | Review lsp_diagnostics errors → Fix → Re-verify |

**Error Recovery Flow:**

```
Task fails
    ↓
Analyze error code (refer to table above)
    ↓
Determine handling approach
    ↓
Apply fix / adjustment
    ↓
Retry verification
    ↓
Success → Proceed to next task
Failure → Log the issue → Escalate for manual intervention
```

### Parallel Execution

**Identify parallel opportunities:** Look for tasks in TASKS.md with no dependency relationships.

**Parallel execution rules:**
- Run at most 3 tasks in parallel (to avoid resource contention)
- Use the `dispatching-parallel-agents` skill to manage parallel execution

**Parallel execution template:**
```markdown
## Dispatch the following tasks simultaneously (no dependencies):
1. T012 - [Task name]
2. T013 - [Task name]
3. T014 - [Task name]
```

## Phase 5: Validation & Wrap-up

### Goal
Ensure all tasks are complete, quality standards are met, and the work is ready for delivery.

### Steps

#### 1. Final Verification

```markdown
## Verification Checklist

### Documentation Completeness
- [ ] DESIGN.md is consistent with the implementation
- [ ] All requirements in SPEC.md are implemented
- [ ] All tasks in TASKS.md are marked completed

### Code Quality
- [ ] All tests pass
- [ ] lsp_diagnostics reports no errors
- [ ] Coverage meets target (≥ 80% for core business modules)

### Git Status
- [ ] All changes are committed
- [ ] Branch is ready to push (git push)
```

#### 2. Code Review

Use the `superpowers:requesting-code-review` skill to conduct a code review.

#### 3. Create PR/MR

```bash
# Ensure all changes are committed
git status

# Push the branch
git push -u origin HEAD

# Create PR/MR (using gh or GitLab CLI)
gh pr create --title "feat: {project-name} initial development" --body "$(cat <<'EOF'
## Summary
- [Brief description of what was implemented]

## Verification
- [ ] Tests pass
- [ ] Code review approved
- [ ] Documentation updated

## Changes
<!-- List major file changes -->
EOF
)"
```

### Acceptance Criteria
- [ ] All tasks in TASKS.md are marked completed
- [ ] All tests pass
- [ ] lsp_diagnostics reports no errors
- [ ] Code review approved
- [ ] PR/MR has been created

## Project Structure Template

```
{project}/
├── docs/
│   ├── DESIGN.md          # Architecture design
│   ├── SPEC.md            # Functional specification
│   ├── PLAN.md            # Implementation plan
│   └── TASKS.md           # Task list
├── src/                   # Source code
├── tests/                 # Test files
├── scripts/               # Scripts
├── README.md              # Project description
└── AGENTS.md              # Agent collaboration guide
```

## Key Files Reference

| File | Required | Description |
|------|----------|-------------|
| DESIGN.md | Yes | Architecture design, created in Phase 1 |
| SPEC.md | Yes | Functional specification, created in Phase 2 |
| PLAN.md | Yes | Implementation plan, created in Phase 3 |
| TASKS.md | Yes | Task list, created in Phase 3 |
| AGENTS.md | Recommended | Strongly recommended for multi-agent collaboration |

## Differences from Superdev (video MCP variant)

| Aspect | Superdev (video MCP) | SuperDev (this skill) |
|--------|---------------------|-----------------------|
| Target | Video generation MCP server | General-purpose applications |
| Doc language | Primarily Chinese | No constraint |
| Specific constraints | Distributed / queue-based | None |
| Applicability | MCP Server | Any application |

## Notes

1. **Commit in small steps**: Commit after each task is complete — easier to review and roll back
2. **Task granularity**: Each task should be completable in 1–4 hours
3. **Acceptance criteria**: Every task must have explicit, testable acceptance criteria
4. **Dependency management**: Clearly mark task dependencies in TASKS.md
5. **Continuous integration**: Recommend configuring CI to run tests and checks automatically

## Quality Standards

| Dimension | Standard |
|-----------|----------|
| Test coverage | ≥ 80% (core business modules) |
| Type check | No errors |
| Lint | Passes |
| Tests | All pass |
| Documentation | Kept in sync with implementation |

## Quick Reference

| Phase | Key Commands / Actions |
|-------|----------------------|
| Phase 0 | Check `/speckit.specify --help` + DESIGN.md health (≥ 60%) |
| Phase 1 | Create / update `docs/DESIGN.md` |
| Phase 2A | Run `/speckit.specify/clarify/plan/tasks/analyze` |
| Phase 2B | Manually create `docs/SPEC.md` |
| Phase 3 | Create `docs/PLAN.md`, `docs/TASKS.md` |
| Phase 4 | Dispatch tasks via `task(category="deep", ...)` |
| Phase 5 | Create PR/MR via `gh pr create` |
