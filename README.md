# Wheelhouse

## What is Wheelhouse?

Wheelhouse is a web-based workshop management system designed specifically for a neighbourhood bicycle repair shop. It digitizes the entire repair lifecycle—from bike intake and intake condition photo recording, to technical diagnostic estimation, customer approval, job execution, and pickup.

The system replaces manual paper tags and individual mechanic notebooks with a centralized screen, eliminating status confusion, preventing mix-ups between identical bike models, tracking promised completion dates, and preserving the complete maintenance history for every physical bicycle.

## Who uses it?

Wheelhouse serves both internal workshop staff and external customers with role-specific access:

- **Counter Staff (Front Desk):** Handles customer intake, assigns physical tags, takes intake condition photos, looks up real-time repair status when customers call or walk in, and processes bike handoffs.
- **Mechanics (Workshop):** Documents technical diagnoses, itemizes repair jobs from the standard service catalog ("wall list"), tracks repair progress, and marks jobs ready for pickup.
- **Shop Owner / Manager:** Monitors overall workshop throughput, oversees overdue promised dates, updates the standard price list, and reviews longitudinal service history tied to specific bike serial numbers.
- **Customers & Public:** Accesses a public catalog displaying standard service descriptions and base prices ("wall list"), without access to internal customer records or private repair tickets.

## Project Documentation

The complete specifications produced for this system are organized in the following documents:

- [**User Stories & Acceptance Criteria**](docs/user-stories.md) — Requirements, role motivations, INVEST story splitting, and verifiable acceptance criteria.
- [**Domain Model & Entity Lifecycle**](docs/domain-model.md) — Relational schema (DBML), entity-to-story mapping, the Model–Unit pattern defense, stored vs. derived data decisions, and the repair state machine.
- [**Decisions Record**](docs/decisions.md) — Key business questions, operational assumptions, and architectural trade-offs.
- [**Wireframes & Screen Navigation**](docs/wireframes.md) — Low-fidelity screen layouts, role-specific views, and navigation flow graphs.
