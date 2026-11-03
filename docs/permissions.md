# Workshop permissions

The public can read the service index and show pages. Other resource pages require a signed-in account. “Own” means assigned to the staff member linked to the mechanic's account; an unlinked mechanic has no own repairs. Handed back means status `completed`.

## Customers

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes | No |
| update | Yes | Yes | No |
| destroy | Yes | No | No |

## Bikes

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes | No |
| update | Yes | Yes | No |
| destroy | Yes | No | No |

## Services

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Yes |
| show | Yes | Yes | Yes |
| new | Yes | No | No |
| create | Yes | No | No |
| edit | Yes | No | No |
| update | Yes | No | No |
| destroy | Yes | No | No |

## Staff members

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Yes |
| show | Yes | Yes | Yes |
| new | Yes | No | No |
| create | Yes | No | No |
| edit | Yes | No | No |
| update | Yes | No | No |
| destroy | Yes | No | No |

## Repairs

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | All | All | Own only |
| show | All | All | Own only |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | All | Not handed back | Own, not handed back |
| update | All | Not handed back | Own, not handed back |
| destroy photo | All | Not handed back | Own, not handed back |
| destroy | Yes | No | No |

Owner and counter can submit all offered fields; mechanics can submit only status, diagnosis and new intake photos. The intake account is assigned from the session for every new repair. Repair lists on other pages use the same repair scope.
