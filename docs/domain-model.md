# Domain Model and Lifecycle

This document presents the relational data model, entity traceability, lifecycle state transitions, and design decisions for Wheelhouse.

## 1. Relational Diagram

![Domain Model Diagram](domain-model.svg)

### DBML Code (dbdiagram.io)

```dbml
Table customers {
  id bigint [pk, increment]
  name varchar [not null]
  phone varchar [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table bikes {
  id bigint [pk, increment]
  customer_id bigint [not null]
  make varchar [not null]
  model varchar [not null]
  color varchar [not null]
  serial_number varchar [unique, not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table staff_members {
  id bigint [pk, increment]
  name varchar [not null]
  role varchar [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table services {
  id bigint [pk, increment]
  name varchar [unique, not null]
  description text [not null]
  standard_price decimal(8,2) [not null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table repairs {
  id bigint [pk, increment]
  bike_id bigint [not null]
  intake_by_staff_id bigint [not null]
  assigned_mechanic_id bigint [null]
  status varchar [not null, default: 'Received']
  promised_on date [not null]
  approved_by_customer boolean [null]
  completed_at timestamp [null]
  picked_up_at timestamp [null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}

Table repair_items {
  id bigint [pk, increment]
  repair_id bigint [not null]
  service_id bigint [not null]
  charged_price decimal(8,2) [not null]
  notes text [null]
  created_at timestamp [not null]
  updated_at timestamp [not null]
}
```

## 2. Repair Lifecycle

### Allowed States

- Received: Bike is in the shop and tagged.
- Diagnosed: Mechanic inspected the bike and wrote notes.
- Awaiting Approval: Staff called customer with the estimated cost.
- In Progress: Customer approved and mechanic is working on the bike.
- Ready for Pickup: Work is complete and bike is on the ready rack.
- Completed: Customer paid and took the bike home.
- Declined: Customer rejected the estimate and picked up the untouched bike.

### Allowed Transitions

- Received -> Diagnosed: Mechanic finishes technical inspection.
- Diagnosed -> In Progress: Simple repairs that do not need phone confirmation.
- Diagnosed -> Awaiting Approval: Complex repairs that require customer agreement.
- Awaiting Approval -> In Progress: Customer accepts the estimate.
- Awaiting Approval -> Declined: Customer rejects the estimate.
- In Progress -> Ready for Pickup: Mechanic finishes all repair jobs.
- Ready for Pickup -> Completed: Customer pays and collects the bike.
- Declined -> Completed: Customer collects the untouched bike.

### Disallowed Transitions

- Received -> Ready for Pickup: A bike cannot be marked ready without diagnosis and work.
- Received -> Completed: A bike cannot leave the shop directly on arrival.
- Awaiting Approval -> Ready for Pickup: Work cannot be finished before customer approval.
- Completed -> In Progress: A closed repair cannot be reopened.

## 3. Entity Traceability

| Entity | Story | Justification |
|---|---|---|
| customers | Story 1 | Needed to store customer contact information. |
| bikes | Story 1, 10 | Needed to identify physical bikes and store maintenance history by serial number. |
| staff_members | Story 1, 6, 9 | Needed to distinguish counter staff, mechanics, and the shop owner. |
| services | Story 7, 11, 12 | Needed for the standard price list on the wall and website. |
| repairs | Story 1, 2, 8, 9 | Needed to track the intake, promised date, and repair lifecycle status. |
| repair_items | Story 7, 11 | Needed to connect services to a repair with historical prices. |

## 4. Changes since Lab 3

Differences between the initial conceptual domain model and the PostgreSQL schema:

- **`intake_photos` table omitted**: Photo uploads and file attachments are postponed to a dedicated media handling iteration.
- **`repairs.diagnostic_notes` column omitted**: Detailed mechanic diagnoses will move into their own structured table in a future phase.
- **`repairs.promised_date` renamed to `promised_on`**: Follows Rails conventions (`_on` for calendar days, `_at` for timestamps).
- **`updated_at` column added to all tables**: Added standard Rails timestamp tracking alongside `created_at`.
- **Primary and foreign keys use `bigint`**: Standardized on PostgreSQL 64-bit integer IDs created by Rails migrations.
- **`services.standard_price` and `repair_items.charged_price` use `decimal(8, 2)`**: Defined fixed precision and scale for currency instead of float/generic decimal.
- **`services.name` unique index added**: Prevents duplicate service names in the catalog.
- **`bikes.serial_number` unique index added with `NOT NULL`**: Enforces unique serial numbers for each physical bicycle at the database level.
- **`repairs.status` defaults to `'Received'` with `NOT NULL`**: Ensures newly created repair tickets start in the initial lifecycle state.
- **`repairs.assigned_mechanic_id` allows `NULL`**: A mechanic is assigned after counter intake, so the ticket starts without an assigned mechanic.
- **`repairs.approved_by_customer` allows `NULL`**: The customer decision is only known after inspection and estimate.
- **`repairs.completed_at` and `repairs.picked_up_at` allow `NULL`**: Timestamps remain null while work is pending or before customer collection.
- **`repair_items.notes` allows `NULL`**: Custom notes on individual repair items are optional.
- **Foreign key constraints omitted**: Foreign key database constraints and model associations are postponed to the associations milestone (Lab 7) to keep this migration focused on table structure.

## 5. Design Decisions

### The Thing and the Copy of the Thing

In March, the shop gave back the wrong bike because two customers brought the same bike model, two blue Trek Marlins. A single bike table with a name and a quantity number cannot tell two physical bikes apart. Our model uses a separate bike record with a unique serial number. This makes sure every physical bike is tracked on its own, even when they have the same brand, model, and color.

### Derived vs. Stored Values

- Derived value: The overdue status of a repair is not stored in the database. It is calculated by comparing the promised date with today's date. Storing a true/false column requires daily updates and can show wrong data.
- Stored value: The charged price in the repair items table is saved as a fixed number. If we only read the price from the services catalog, the price update in January would change past customer invoices. Storing the charged price protects old receipts.
