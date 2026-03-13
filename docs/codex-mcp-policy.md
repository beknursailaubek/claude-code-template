# Codex MCP Policy

Rules governing when and how Claude Code delegates tasks to Codex via MCP.

---

## What Codex Is

Codex is a bounded execution engine accessed via the `codex` MCP tool. It is a code generator and editor that works within a defined scope.

Codex is **not**:
- An architect or planner
- A code reviewer
- A project context holder
- A decision maker

Codex is **good at**:
- Implementing a single, well-specified function or module
- Mechanical refactors with explicit before/after definitions
- Writing tests given a precise behavioral spec
- Generating boilerplate given a clear pattern to follow

---

## Allowed Use Cases

| Use Case | Example |
|---|---|
| Implement a specified function | "Add `get_user_by_email(email) -> Optional[User]` to UserRepository using SQLAlchemy" |
| Mechanical refactor | "Rename all uses of `UserDTO` to `UserSchema` in these 3 files" |
| Write tests for a spec | "Write pytest tests for this function covering success, not-found, and invalid-input cases" |
| Generate boilerplate | "Generate a CRUD router for the `Product` model following the existing pattern in `routers/user.py`" |
| Add a serializer/deserializer | "Add a Pydantic schema for the `Order` model matching these fields" |

---

## Disallowed Use Cases

| Use Case | Why Disallowed |
|---|---|
| Designing a new system or module | Requires cross-module reasoning and architectural judgment |
| Any change to auth or security logic | Too high risk; requires human review at every step |
| Applying database migrations | Requires explicit human confirmation; Codex cannot ask |
| Tasks with unclear scope | Unpredictable output; wasted cycles |
| Multi-module changes in a single call | Too broad; unverifiable; violates minimal-diff principle |
| Choosing between technical approaches | Architecture decision; belongs to Claude |

---

## How to Prepare a Codex Delegation

**Always use the `codex-task-contract` skill before calling Codex.**

A contract must include:
1. **Objective** — one sentence: what should exist after this call
2. **Scope** — which module, layer, or file area
3. **Context** — what Codex needs to know about the existing system
4. **Inputs** — relevant files to read, function signatures, data shapes
5. **Files allowed to change** — explicit list
6. **Files forbidden to change** — explicit list
7. **Constraints** — naming, patterns, libraries, no new deps, etc.
8. **Acceptance criteria** — testable, specific
9. **Validation commands** — exact commands to run after Codex returns

---

## Good Codex Task — Example

```markdown
**Objective:** Add `calculate_discount(order: Order, coupon: Coupon) -> Decimal` to the pricing service.

**Scope:** `app/services/pricing.py` only.

**Context:** The pricing service uses plain functions (no class). Orders have a `subtotal: Decimal` field. Coupons have `discount_type: Literal["percent", "fixed"]` and `discount_value: Decimal`. Percent discounts are applied to subtotal; fixed discounts are subtracted directly, floored at 0.

**Inputs:**
- Read: `app/services/pricing.py` (for existing function patterns)
- Read: `app/models/order.py`, `app/models/coupon.py` (for data shapes)

**Files allowed to change:**
- `app/services/pricing.py`
- `tests/unit/test_pricing.py`

**Files forbidden to change:**
- `app/models/` (any file)
- `app/api/`

**Constraints:**
- Follow existing function style in pricing.py
- Use `Decimal` for all monetary values, never `float`
- No new imports beyond what pricing.py already uses

**Acceptance criteria:**
- [ ] Function exists with correct signature
- [ ] Percent discount returns subtotal * (1 - discount_value/100), rounded to 2 decimal places
- [ ] Fixed discount returns max(0, subtotal - discount_value)
- [ ] Tests cover: percent, fixed, zero discount, discount > subtotal (floor at 0)
- [ ] pytest tests/unit/test_pricing.py passes

**Validation commands:**
pytest tests/unit/test_pricing.py -v
ruff check app/services/pricing.py
```

---

## Bad Codex Task — Example

```
"Update the pricing system to support coupons and make sure it integrates with checkout."
```

Why this is bad:
- "Pricing system" is not a specific file
- "Integrates with checkout" is a cross-module architecture task
- No acceptance criteria
- No file constraints — Codex might change anything
- No existing pattern reference — Codex will invent one

---

## How Claude Reviews Codex Output

After Codex returns, Claude must:

1. **Read the diff** — every changed file, line by line
2. **Check each acceptance criterion** — verify it is met, not just that the code exists
3. **Run validation commands** — do not skip; paste output into the review
4. **Apply `code-review` skill** — classify any issues
5. **Accept or reject**:
   - **Accept** — if all acceptance criteria met and no BLOCKER issues
   - **Reject with corrective contract** — if specific, fixable issues exist
   - **Reject and escalate to Claude** — if the output is fundamentally wrong or the task was underspecified

**Never auto-accept.** A Codex output that "looks right" is not the same as one that has been verified.

---

## Codex Unavailability Fallback

If the `codex` MCP tool is unavailable (connection error, usage limit, permission denied):

1. Continue using Claude Code tools directly (Edit/Write/Bash)
2. Apply the same task contract structure for internal planning
3. Run the same verification commands
4. If direct editing is not permitted, produce a precise unified diff or file-by-file instructions

The workflow quality should not degrade because Codex is unavailable.
