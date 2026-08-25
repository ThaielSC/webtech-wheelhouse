# Building the Right Software: From Requirements to Domain Models, User Stories, and UX

This chapter presents a comprehensive, practical guide to the pre-coding phase of software development: how to understand and define what to build, translate needs into user stories and acceptance criteria, structure work with vertical slices, design the relational data model (including patterns like Model–Unit and many-to-many join tables), manage entity lifecycles with state machines, and sketch UI/UX wireframes that validate flows early. The goal is to equip you with a coherent methodology to avoid expensive rework by shifting analysis and validation to the earliest stages.

## 1\. Why Early Requirements Matter: The Cost of Late Errors

Software delivery typically flows through four phases: Requirements, Design, Development, and Production. A key engineering principle is that the cost of fixing an error grows exponentially the later it is discovered.

- Error in Requirements: Cheap to fix with a conversation; realign goals before any code exists.
- Error in Design: More expensive; update diagrams, reconsider database schemas and architecture.
- Error in Development: Costly; refactor or rewrite code, adjust schema, rebuild features.
- Error in Production: Most expensive; correct code and schema, perform complex data migrations, fix corrupted data, notify affected users, and manage reputational impact.

Concrete example: a payments system goes live with a credit-card field sized for 15 digits instead of 16. Fixing it requires schema changes, code updates, and remediation of failed transactions, including user outreach. The lesson: time invested up front—one minute clarifying requirements can save three or more minutes later—prevents building the wrong thing.

## 2\. Moving Beyond Waterfall: Why Agile Iteration Works

The traditional waterfall approach (a massive specification followed by months of isolated building) often yields misaligned products because expectations evolve and documents are imperfect. Agile shifts to short cycles with continuous collaboration:

- Constant feedback: Show incremental progress regularly to detect misalignment early.
- Reduced risk: Discover wrong directions after a sprint, not after a year.
- Adaptability: Respond to changing business needs; requirements are expected to evolve.

In agile, a “requirement” is not a rigid contract; it’s the start of a conversation. The intent is to articulate value and constraints, then negotiate the simplest solution that meets real needs.

## 3\. Requirements as Conversations: Avoiding Two Common Pitfalls

Two failure modes recur when handling requirements:

1. Building exactly what was asked without probing the problem. Example: “The entrance is far; build a pedestrian bridge.” A better path might be a shorter route around the building. Engineers should co-create solutions by questioning and improving initial ideas.
2. Assuming understanding without clarifying constraints. A “simple” grade-entry system might fail if users lack a mouse or have visual impairments. Hidden constraints determine usability.

Treat requirements as prompts for dialogue that uncover edge cases, constraints, and success criteria prior to development.

### Example Domain: Equipment Lending at a University

Current process: shared Excel + WhatsApp. Pain points:

- The administrator loses track of who has what.
- No tracking of due dates; late returns are common.
- Availability is unclear.
- Memory-dependent, manual control.

**Problem statement:** “Students request equipment; I note it in a spreadsheet, but I never really know what’s out or when it’s due back. People keep things for weeks. I need to see what’s available and who’s late.”

This is a cry for help and a starting point for structured requirements, not a full specification.

## 4\. User Stories: The Shared Language of Value

A user story expresses a capability from the user’s perspective, anchored in value:

**As a**`<role>`, **I want to**`<action>` **so that**`<benefit>`.

- Role: Who wants this and will use it (user persona).
- Action: What they need to do.
- Benefit: Why it matters—the value delivered. This “so that” is essential for evaluating success, choosing simpler solutions, and aligning the team.

Example:

> As a student, I want to see which items are available for checkout this week so that I do not walk across campus for a camera that is already checked out.

### Why the “so that” Clause Matters

- Enables solution negotiation: If the goal is identification, perhaps email suffices instead of collecting national ID or birth date.
- Supports trade-off evaluation: Optimizing for speed, security, or fewer clicks depends on understanding the goal.
- Aligns cross-functional teams: Designers, developers, and stakeholders converge on the same outcome.

### Roles and Permissions: Who Can Do What

Permissions define visible actions per role. Misconfigured permissions cause severe security issues. In an equipment rental app:

- Student: Request items; view own loan history.
- Staff Member: Approve/issue items; view all active loans and overdue status.
- Visitor: Browse public catalog; cannot request.

Model roles early; enforce later. This prevents unauthorized actions (e.g., changing another user’s email), which have occurred in real systems.

## 5\. Acceptance Criteria: Making “Done” Objective

User stories are intentionally brief; the details emerge through conversation. Acceptance criteria formalize those details into objective, testable conditions that prevent scope creep and define “done.”

Example Story:

> As a staff member, I want to view a list of overdue loans so that I can follow up with students to retrieve the items.

**Acceptance Criteria:**

- Given a loan has a due date in the past and the item is not marked returned, then it appears on the overdue list.
- Given the list is displayed, then sort by most overdue first.
- Given an item on the list, then show item’s name, student’s name, and days overdue.
- Given there are no overdue loans, then show “There are no overdue items.”

## 6\. Crafting Effective Stories: Ask Questions and Apply INVEST

### Ask Questions to Remove Ambiguity

Clarify business rules:

- What exactly counts as overdue? Midnight vs. next day? Fixed return hour?
- How do weekends and holidays affect lateness?
- Who sees overdue status? Should students be notified? Beware perverse incentives (e.g., preferring late returns to collect fines).

These clarifications feed directly into acceptance criteria.

### INVEST: Characteristics of Good Stories

- Independent: Minimize dependencies so work can proceed in parallel.
- Negotiable: The three-line story invites conversation; start with simple solutions (e.g., windsock vs. expensive wind sensors for rural airfields).
- Valuable: Must deliver user value; avoid perfectly engineered solutions to non-problems (e.g., aircraft without onboard computers).
- Estimable: Team can roughly size the work; break down until small enough to estimate (often within a day).
- Small: Prefer many small stories for rapid feedback, reduced risk, and continuous progress.
- Testable: Define verifiable outcomes; supports automated tests and prevents regressions.

## 7\. Structuring Work: Vertical Slicing Over Layers

Avoid splitting by technical layers (database, backend, frontend) because it delivers no user value until the very end. Instead, cut vertical slices—small, end-to-end functionality for each story:

Incorrect (horizontal slicing):

1. Build loans table; 2) Build controllers; 3) Build views.

Correct (vertical slicing by value):

- As a staff member, I want to record a new loan item so that the spreadsheet is no longer the source of truth.
- As a staff member, I want to mark an item as returned so that it becomes available for others.
- As a staff member, I want to see a list of overdue loans so that I can follow up with students.

Each slice touches database, backend logic, and UI as needed, yielding a usable increment and immediate feedback.

## 8\. From Stories to Data Model: Entities, Relationships, and Join Tables

User stories provide clues for designing your relational schema.

### Identify Entities from Nouns

Stories like:

- “As a student, I want to see which items are available…”
- “As a staff member, I want to see overdue loans…”

Suggest entities: Student, Item, Loan, StaffMember.

Distinguish nouns:

- Attributes: name (Student), returned\_at (Loan).
- Synonyms: gear, equipment, item → choose one term (Item) to avoid confusion.
- Descriptive words: narrative context like “campus” may not become data.

### Define Relationships and Cardinality

- One-to-Many (1): A Student has many Loans; a Loan belongs to one Student. Implement with foreign key on the “many” side (`loans.student_id`).
- Many-to-Many (M): Students borrow many Items; Items are borrowed by many Students. Implement with a join table.

### Join Table Roles

- Join table as concept: The relationship between Student and Item is a Loan. The `loans` table includes `student_id`, `item_id`, `loan_date`, `due_date`, `returned_at`.
- Join table as simple connector: For Post–Tag, use posts\_tags with post\_id and tag\_id.

This approach keeps relationship-specific attributes in the join table, not in the base entities.

## 9\. Modeling Identical but Traceable Units: The Model–Unit Pattern

Problem: Four identical “Canon T7” cameras must be tracked individually. If you model `Item { name: “Canon T7”, quantity: 4 }`, you lose traceability—cannot know which physical unit is with which student or who damaged a device.

Solution: Two-entity Model–Unit pattern:

- ItemModel: the generic product type (name, brand, description).
- Unit: a specific physical instance linked to ItemModel, with a unique identifier (e.g., serial\_number).

Syntax (dbdiagram-style example):

```
Table ItemModel {
  id integer [pk]
  name string
  description text
  // ... other generic attributes
}

Table Unit {
  id integer [pk]
  item_model_id integer [ref: > ItemModel.id]
  serial_number string
  // ... other unit-specific attributes
}
```

Loan relationships link a Unit to a Student (and StaffMember).

Analogous domains:

- Libraries: Book (title) vs. Copies (physical books).
- Airlines: Flight vs. Seats (1A, 24C).
- Universities: Course vs. Sections.

## 10\. Building the Relational Diagram for Equipment Lending

Core tables:

- Student and StaffMember: system users.
- ItemModel and Unit: generic model and specific tracked units.
- Loan: connects Unit, Student, and StaffMember; holds lifecycle attributes.

Typical Loan attributes:

- id (PK)
- unit\_id (FK → Unit)
- student\_id (FK → Student)
- staff\_member\_id (FK → StaffMember)
- due\_date
- returned\_at (timestamp; null if pending)

A practical tool for creating and sharing diagrams: dbdiagram.io (text-based syntax made visual).

## 11\. State Machines: Managing Entity Lifecycles

Key entities like Loan have discrete states and allowed transitions. A state machine clarifies the lifecycle and enforces valid flows.

Example Loan lifecycle:

1. Requested
2. Approved / On Loan
3. Returned
4. Canceled

Define which transitions are allowed (e.g., Requested → Approved → Returned). Disallow invalid jumps (Requested → Returned).

### Computed vs. Stored States

Do not persist derived flags that can be computed from canonical data; they risk inconsistency.

Overdue is computed:

A loan is overdue if `loan.due_date` is in the past AND `loan.returned_at` is null.

Analogy: store `date_of_birth`, compute age; do not store age.

## 12\. UI/UX Wireframing: Validate Flows Early, Not Pixel-Perfect Designs

Wireframes are low-fidelity sketches focusing on structure and user flow, ideal for quick iteration and feedback before costly front-end work.

Why low-fidelity first:

- Focus conversations on layout and functionality, not color or copy details.
- Minimize rework; sketches are cheap to discard and revise.
- The classic “napkin sketch” is powerful for communicating the core idea.

### Mapping Stories to Screens

From the lending domain, likely screens:

- A filterable catalog of ItemModels.
- An ItemModel detail view (optionally showing loan history).
- A form to request a new Loan.
- Student dashboard with active loans.
- Staff dashboard of all loans, sorted by due proximity or overdue status.

Ensure screens are navigable without relying on the browser’s Back button; define clear flows.

### Core UX Principles

- Hierarchy: Visual structure communicates importance; prominent titles and clear primary actions.
- Consistency: The most critical habit-forming principle.
  - Layout: Keep “Save” in the same place; “Back” arrow consistently located.
  - Color and style: If “Save” is blue and “Cancel” is gray, maintain across the app.
  - Inconsistency causes errors; users act by recognition and habit.
- Feedback: Always show system response.
  - Instant actions: success toast/message.
  - Longer actions: loading indicator, progress bar, or message like “Processing your request. We will email you when it’s ready.”
  - Without feedback, users may repeat actions and overload the system.

## 13\. The Economics of Shifting Left

The entire pre-coding methodology—requirements conversations, user stories with acceptance criteria, vertical slicing, domain modeling, state machines, and wireframes—exists to catch misunderstandings early. Fixes in requirements are cheap; fixes in design are manageable; fixes in code are expensive; fixes in production are extremely costly and reputationally risky.

Investing in clarity and validation before coding yields predictable projects, faster feedback cycles, better UX, and robust data integrity.

## 14\. Putting It All Together: A Coherent Workflow

1. Elicit the problem with conversations; resist building too fast.
2. Write user stories (As a…, I want…, so that…); define roles and permissions.
3. Negotiate scope and clarify constraints; derive acceptance criteria.
4. Plan work in vertical slices; deliver end-to-end increments per story.
5. Model the domain: entities, relationships, cardinality; apply Model–Unit where traceability is required; design join tables for M.
6. Define state machines for lifecycles; compute derived states like “overdue.”
7. Wireframe low-fidelity UI; validate flows and feedback early.
8. Iterate with stakeholders; adapt stories and criteria; maintain consistency and value focus.
9. Implement with automated tests guided by acceptance criteria; keep stories testable.

By following this structure, teams consistently build the right software—aligned with user needs, secure by design, and resilient in production—while minimizing waste and avoiding the trap of feeling “productive” without making meaningful progress.
