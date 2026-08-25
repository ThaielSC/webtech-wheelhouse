# User Stories and Acceptance Criteria

This document lists the user stories and acceptance criteria for the Wheelhouse bike shop system.

## 1. System Roles

- Counter staff: Takes bikes in, answers customer questions, and returns bikes.
- Mechanic: Inspects bikes, takes photos, and repairs bikes.
- Shop owner: Checks delayed repairs, manages price lists, and views bike history.
- Customer: Checks service prices on the website.

## 2. User Stories

### Counter Staff

1. As counter staff, I want to write down the customer name, phone number, bike model, and serial number, so that we can identify the bike and contact the owner.
2. As counter staff, I want to see the status of a repair on screen when a customer calls, so that I can tell them if their bike is ready without walking to the workshop.
3. As counter staff, I want to record if the customer accepts or rejects the repair cost, so that mechanics know if they should start working.
4. As counter staff, I want to mark a repair as picked up when the customer takes the bike, so that we know the bike is no longer in the shop.

### Mechanic

5. As a mechanic, I want to attach photos of scratches and damage when the bike arrives, so that we have proof of the original condition.
6. As a mechanic, I want to write detailed notes about the bike problems, so that other workers can understand what is wrong.
7. As a mechanic, I want to choose services from the price list and adjust the price if needed, so that we can give a fair cost to the customer.
8. As a mechanic, I want to change the repair status to ready, so that counter staff know the work is complete.

### Shop Owner

9. As the shop owner, I want to see a list of repairs that missed their promised date, so that we can fix delays before customers complain.
10. As the shop owner, I want to see all past repairs for a bike using its serial number, so that we know the full history of the bike even if it changes owners.
11. As the shop owner, I want to update the standard service prices in January, so that future repairs use new prices while old invoices stay the same.

### Customer

12. As a customer, I want to see the repair price list on the website, so that I know standard costs before visiting the shop.

## 3. Large Story and Split

### Original Large Story

As a worker, I want to record customer details, inspect the bike, take photos, estimate costs, call the customer, repair the bike, and return it, so that the whole repair process is done.

Reason: This story is too big because it covers many different steps, roles, and days of work.

### Split Stories

We split the large story into smaller pieces:

- Story 1: Intake registration (Counter staff records customer and bike details).
- Story 7: Service selection (Mechanic selects services and sets prices).
- Story 4: Bike pickup (Counter staff marks the repair complete and returns the bike).

## 4. Acceptance Criteria

### Criteria for Story 2: Immediate Status Lookup

- Given a customer phone number or serial number, when counter staff searches, then the screen shows the bike model, customer name, promised date, and current status.
- Given a repair with status Ready, when viewed on screen, then the screen shows the total price to pay.
- Given a search with no results, when the search runs, then the screen displays: "No repairs found."

### Criteria for Story 5: Intake Condition Photos

- Given a new repair, when a worker uploads photos of the bike, then the photos are saved with the date and time.
- Given a repair with photos, when viewing the repair details, then the user can see image previews.
- Given a repair without photos, when viewing the photo section, then the screen displays: "No photos uploaded for this repair."

### Criteria for Story 9: Overdue Repair Tracking

- Given an active repair with a promised date in the past, when the owner opens the dashboard, then the repair appears in the overdue list with the days of delay.
- Given the overdue list, when displayed, then the most delayed repairs appear at the top.
- Given no late repairs in the shop, when the owner views the list, then the screen displays: "No overdue repairs."

### Criteria for Story 11: Catalog Price Management

- Given a service in the price list, when the owner updates its price, then new repairs use the new price.
- Given old invoices created before the update, when viewed, then their saved prices do not change.
- Given a repair already in progress, when the price list changes, then the price on that current repair does not change.
