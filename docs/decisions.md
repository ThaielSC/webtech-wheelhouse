# Decisions Record

This document records three questions where the shop description is not completely clear, the assumptions we made to design the system, and how the data model would change if the answer is different.

## 1. Bike Ownership and Past Invoices

### Question
When a customer sells a bicycle to a new owner, should the shop keep a record of who owned the bike during each past repair?

### Our Assumption
We assumed that a bike only needs to store its current owner. When a bike changes owners, staff updates the customer link on the bike record. Old repair records stay connected to the bike serial number so the new owner can see what was fixed in the past.

### If the Answer is Different
If the shop must track past customer invoices for tax or accounting reasons, we would need to store the customer id directly inside the repair table, or create a bike ownership history table with start and end dates.

## 2. Spare Parts and Stock Inventory

### Question
Does the shop need to track physical spare parts and warehouse stock, or are parts billed as items from the service price list?

### Our Assumption
We assumed that replacement parts like chains or forks are billed as line items from the standard service catalog. Specific part details are written in the mechanic diagnosis notes without tracking inventory stock quantities.

### If the Answer is Different
If the shop needs to track stock levels, part numbers, and component costs separately from labor, we would need to add a parts table and a repair parts join table.

## 3. Mechanic Assignment per Repair

### Question
Does a single mechanic complete the whole repair, or do different mechanics work on separate services for the same bike?

### Our Assumption
We assumed that one primary mechanic is assigned to each bike repair ticket. That mechanic performs the diagnosis and completes the selected jobs.

### If the Answer is Different
If different mechanics work on different services for the same bicycle, we would remove the assigned mechanic column from the repair table and move it to the repair items table.
