# Wheelhouse API v1

Base URL: `http://localhost:3000/api/v1`. All responses are JSON, including
when `Accept` requests HTML. Collections are arrays, without pagination.
Private routes require `Authorization: Bearer YOUR_TOKEN`; query/body tokens
are ignored. Configure `api.token` in encrypted credentials as described in the README.

| Verb | Path | Token | Statuses |
|---|---|---|---|
| GET | `/api/v1/services` | No | 200 |
| GET | `/api/v1/services/:id` | No | 200, 404 |
| POST | `/api/v1/services` | Yes | 201, 400, 401, 422 |
| GET | `/api/v1/repairs?state=completed` | Yes | 200, 400, 401 |
| GET | `/api/v1/repairs/:id` | Yes | 200, 401, 404 |

Unknown API paths or unsupported methods answer 404 in the same error shape.
Services are ordered by the model's `by_name` scope; repairs by
`by_promised_date` (promised day, then creation time). GET never changes data.
`state` is optional; its allowed values are the enum keys `received`, `diagnosed`,
`awaiting_approval`, `in_progress`, `ready_for_pickup`, `completed`, `declined`.
An unknown or empty state returns 400, listing the current enum keys.

## Service

Index contains an array of these documents. Show and create return this same hash.
`repairs_count` counts distinct repairs containing the service, even if a repair
has several lines for it.

```json
{"id":1,"name":"Tune-up","standard_price":"35.20","repairs_count":2}
```

Create with `Content-Type: application/json` and this body:

```json
{"service":{"name":"Tune-up","description":"Adjust gears and brakes","standard_price":"35.20"}}
```

Only `name`, `description`, and `standard_price` are permitted. Other attributes
are discarded. The description is required by the existing model but is not part
of the public wall list. Success returns 201 and `Location`, the absolute URL of
the new API service. Missing, empty, malformed, or entirely unrecognized service
attributes return 400. Model validation failures return 422 with exactly the
validation messages used by the form.

## Repair and repair collection

Show returns one object; index returns an array, including `[]` when none match.
Dates are ISO 8601 calendar days. `handed_back_on` is null until pickup.
`approved_by_customer` is the lifecycle's customer answer: true (approved), false
(declined), or null (not answered). `overdue` means not handed back and promised
before today. Line prices are historical charges; `total` sums these charges.

```json
{
  "id":7,
  "state":"completed",
  "received_on":"2026-10-15",
  "promised_on":"2026-10-18",
  "handed_back_on":"2026-10-18",
  "bike":{"brand":"Trek","model":"Marlin","serial_number":"TRK-001"},
  "customer":{"name":"Ana Pérez"},
  "lines":[{"service_name":"Tune-up","charged_price":"30.10"}],
  "total":"30.10",
  "overdue":false,
  "approved_by_customer":true
}
```

A collection of repairs has the same objects:

```json
[
  {
    "id":7,"state":"completed","received_on":"2026-10-15",
    "promised_on":"2026-10-18","handed_back_on":"2026-10-18",
    "bike":{"brand":"Trek","model":"Marlin","serial_number":"TRK-001"},
    "customer":{"name":"Ana Pérez"},
    "lines":[{"service_name":"Tune-up","charged_price":"30.10"}],
    "total":"30.10","overdue":false,"approved_by_customer":true
  }
]
```

## Errors

Every error is an object containing only `errors`, an array of strings:

```json
{"errors":["Resource not found"]}
```

400 means unreadable/missing service attributes or an invalid state filter;
401 means a missing/wrong Bearer token; 404 means a missing record or API route;
422 means validation failed. Handle non-2xx responses by reading `errors`.

## Decisions and browser access

All monetary values (`standard_price`, `charged_price`, `total`) travel as decimal
**strings with exactly two decimal places**, preserving the database's decimal
representation without requiring clients to parse binary floating point. The shop
uses USD, matching its existing dollar price display; the page formats USD with
two decimals. JSON ids and counts are numbers; booleans and null remain JSON types.

Repairs omit foreign keys, customer phone, staff identity, bike color, diagnosis,
photos, line notes, internal timestamps and completion time. Accounting needs the
bike identity, customer name, pickup day and actual charges, not contact details,
internal assignments or workshop diagnostic/media records.

Only GET requests for public service collection/detail receive CORS permission,
only for `https://thaielsc.github.io` and `http://localhost:5500`. Private routes
and POST are not exposed through CORS. Requests without Origin work normally.
Preloading is in API controllers: service collections use two queries and repair
collections five when nonempty, regardless of collection/line size (empty related
collections may need fewer).

Implementation references: [Rails HTTP token authentication](https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Token.html)
and [rack-cors configuration](https://github.com/cyu/rack-cors#configuration-reference).
