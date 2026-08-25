#set page(width: 700pt, height: auto, margin: 15pt)
#set text(font: "Liberation Sans", size: 9pt)

#let win(title, body) = rect(width: 100%, stroke: 1pt + luma(100), radius: 3pt, fill: luma(250), inset: 0pt)[
  #rect(width: 100%, fill: luma(70), radius: (top: 3pt, bottom: 0pt), inset: 6pt)[#text(fill: white, weight: "bold", size: 10pt)[#title]]
  #pad(10pt)[#body]
]

#let btn(t) = rect(fill: luma(220), stroke: 1pt + luma(150), radius: 3pt, inset: (x: 7pt, y: 4pt))[#t]
#let input(t, w: 100%) = rect(fill: white, stroke: 1pt + luma(160), radius: 3pt, width: w, inset: 5pt)[#text(fill: luma(110))[#t]]
#let box_panel(body) = rect(fill: white, stroke: 1pt + luma(180), width: 100%, inset: 8pt, radius: 3pt)[#body]

// Screen 1
#text(size: 12pt, weight: "bold")[Screen 1: Status Lookup (Role: Counter Staff)]
#v(4pt)
#win("Wheelhouse — Status Lookup")[
  #grid(columns: (1fr, auto),
    grid(columns: (220pt, auto), gutter: 6pt, input("Enter phone or serial..."), btn("Search")),
    btn("+ New Intake")
  )
  #v(8pt)
  #line(length: 100%, stroke: 0.5pt + luma(180))
  #v(6pt)
  #box_panel[
    #grid(columns: (1fr, 1fr), gutter: 8pt,
      [ *Customer:* [Customer Name] \ *Phone:* xxx-xxx-xxxx \ *Bike:* [Brand Model] (Color) \ *Serial:* SN-XXXXXX ],
      [ *Status:* #rect(fill: luma(220), radius: 2pt, inset: 2pt)[*READY FOR PICKUP*] \ *Promised:* YYYY-MM-DD \ *Mechanic:* [Mechanic Name] \ *Rack:* Shelf XX ]
    )
    #v(6pt)
    #line(length: 100%, stroke: 0.5pt + luma(200))
    #v(4pt)
    #grid(columns: (1fr, auto),
      [ *Services Done:* \ - Service 1 (\$xx.xx) \ - Service 2 (\$xx.xx) ],
      align(right)[ *Total Due:* #text(size: 11pt, weight: "bold")[\$xx.xx] \ #v(3pt) #btn("Mark Picked Up & Paid") ]
    )
  ]
]

#pagebreak()

// Screen 2
#text(size: 12pt, weight: "bold")[Screen 2: Bike Intake (Role: Counter Staff)]
#v(4pt)
#win("Wheelhouse — New Intake")[
  #grid(columns: (1fr, 1fr), gutter: 10pt,
    [ *Customer Name:* \ #input("Name...") #v(4pt) *Phone:* \ #input("xxx-xxx-xxxx") #v(4pt) *Promised Date:* \ #input("YYYY-MM-DD") ],
    [ *Bike Make & Model:* \ #input("Make, Model, Color...") #v(4pt) *Serial Number:* \ #input("SN-XXXXXX") #v(4pt) *Rack Tag:* \ #input("Tag #...") ]
  )
  #v(6pt)
  *Initial Notes:* \
  #input("Describe problem here...", w: 100%)
  #v(6pt)
  *Intake Photos:* \
  #grid(columns: (auto, auto, auto), gutter: 6pt, btn("+ Upload Photo"), btn("photo-1.jpg"), btn("photo-2.jpg"))
  #v(8pt)
  #grid(columns: (1fr, auto), btn("Cancel"), btn("Save & Print Tag"))
]

#pagebreak()

// Screen 3
#text(size: 12pt, weight: "bold")[Screen 3: Mechanic Work (Role: Mechanic)]
#v(4pt)
#win("Wheelhouse — Repair Ticket #XXX")[
  #grid(columns: (1fr, 1fr, auto), gutter: 8pt,
    [ *Bike:* [Make Model] \ *Serial:* SN-XXXXXX ],
    [ *Customer:* [Name] \ *Promised:* YYYY-MM-DD ],
    [ *Status:* #rect(fill: luma(220), radius: 2pt, inset: 3pt)[*In Progress v*] ]
  )
  #v(6pt)
  *Diagnosis Notes:* \
  #input("Write inspection notes here...", w: 100%)
  #v(6pt)
  *Selected Services:* \
  #box_panel[
    #table(columns: (2fr, 1fr, 1.2fr, auto), stroke: 0.5pt + luma(190), fill: (c, r) => if r == 0 { luma(220) } else { white },
      [*Service*], [*List*], [*Charged*], [*Action*],
      [Tune-up], [\$xx.xx], input("$xx.xx", w: 50pt), btn("Remove"),
      [Chain Replacement], [\$xx.xx], input("$xx.xx", w: 50pt), btn("Remove")
    )
    #v(3pt)
    #grid(columns: (auto, 1fr), btn("+ Add Service"), align(right)[*Total: \$xx.xx*])
  ]
  #v(6pt)
  #grid(columns: (1fr, auto),
    [ *Approval:* #rect(fill: luma(235), radius: 2pt, inset: 3pt)[*(x) Approved* ( ) Declined ( ) Pending] ],
    grid(columns: (auto, auto), gutter: 6pt, btn("Save Notes"), btn("Mark Ready for Pickup"))
  )
]

#pagebreak()

// Screen 4
#text(size: 12pt, weight: "bold")[Screen 4: Owner Dashboard (Role: Shop Owner)]
#v(4pt)
#win("Wheelhouse — Owner Dashboard")[
  #rect(fill: luma(235), stroke: 1pt + luma(180), width: 100%, inset: 6pt, radius: 3pt)[
    #text(weight: "bold")[OVERDUE REPAIRS]
    #v(3pt)
    #table(columns: (1fr, 1.2fr, 1fr, 1fr, 1fr), stroke: 0.5pt + luma(190), fill: (c, r) => if r == 0 { luma(210) } else { white },
      [*Serial*], [*Bike*], [*Customer*], [*Promised*], [*Delay*],
      [SN-XXXXX1], [Brand Model 1], [Name 1], [YYYY-MM-DD], [*x days overdue*],
      [SN-XXXXX2], [Brand Model 2], [Name 2], [YYYY-MM-DD], [*x days overdue*]
    )
  ]
  #v(8pt)
  #grid(columns: (1fr, 1fr), gutter: 10pt,
    box_panel[ *Bike History Lookup:* \ #v(3pt) #grid(columns: (1fr, auto), gutter: 4pt, input("Enter serial..."), btn("Search")) ],
    box_panel[ *Service Price List:* \ #v(3pt) #grid(columns: (1fr, auto), gutter: 4pt, text(size: 8.5pt)[Active items: XX], btn("Update Prices")) ]
  )
]
