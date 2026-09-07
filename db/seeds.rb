# Reset data
RepairItem.destroy_all
Repair.destroy_all
Bike.destroy_all
Customer.destroy_all
StaffMember.destroy_all
Service.destroy_all

puts "Seeding Wheelhouse database..."

# Staff members
lucas  = StaffMember.create!(name: "Lucas Morales", role: "Counter Staff")
elena  = StaffMember.create!(name: "Elena Rostova", role: "Mechanic")
mateo  = StaffMember.create!(name: "Mateo Valenzuela", role: "Mechanic")
sofia  = StaffMember.create!(name: "Sofia Alarcon", role: "Mechanic")

# Standard workshop services list
srv_safety_check    = Service.create!(name: "Safety Check & Inspection", description: "Comprehensive safety inspection of frame, brakes, drivetrain, and torque settings.", standard_price: 25.00)
srv_flat_repair     = Service.create!(name: "Flat Tire Repair / Tube Replacement", description: "Puncture inspection, rim tape check, and new tube installation.", standard_price: 15.00)
srv_brake_adj       = Service.create!(name: "Brake Adjustment (Front & Rear)", description: "Cable tension calibration, pad alignment, and rotor/rim cleaning.", standard_price: 30.00)
srv_brake_bleed     = Service.create!(name: "Hydraulic Brake Bleed", description: "Complete fluid flush, air bubble removal, and lever feel restoration per brake.", standard_price: 45.00)
srv_derailleur_tune = Service.create!(name: "Derailleur & Shifting Tune-up", description: "Limit screw setup, cable tension adjustment, and derailleur hanger alignment.", standard_price: 35.00)
srv_drivetrain_cln  = Service.create!(name: "Drivetrain Deep Clean & Lubrication", description: "Degreasing and ultrasonic cleaning of chain, cassette, and chainrings with fresh lube.", standard_price: 50.00)
srv_chain_replace   = Service.create!(name: "Chain Replacement & Sizing", description: "Chain wear inspection, precision link sizing, and new chain installation.", standard_price: 20.00)
srv_wheel_truing    = Service.create!(name: "Wheel Truing", description: "Spoke tension balancing, lateral and radial wheel straightening on the truing stand.", standard_price: 35.00)
srv_bb_service      = Service.create!(name: "Bottom Bracket Service / Replacement", description: "Crankset removal, shell inspection, bottom bracket overhaul or replacement.", standard_price: 40.00)
srv_headset_service = Service.create!(name: "Headset Overhaul & Adjustment", description: "Steerer inspection, bearing cleaning/regreasing, and proper preload adjustment.", standard_price: 35.00)
srv_hub_overhaul    = Service.create!(name: "Wheel Hub Bearing Overhaul", description: "Axle disassembly, cone adjustment, bearing replacement, and marine-grade grease pack.", standard_price: 40.00)
srv_full_overhaul   = Service.create!(name: "Full Workshop Overhaul", description: "Complete bike strip-down, deep clean, bearing service, cable replacement, and road test.", standard_price: 160.00)
srv_fork_service    = Service.create!(name: "Fork & Suspension Air Spring Service", description: "Lower leg inspection, wiper seal replacement, bath oil refresh, and pressure setup.", standard_price: 85.00)
srv_tubeless_setup  = Service.create!(name: "Tubeless Tire Setup & Sealant Injection", description: "Tubeless rim tape installation, valve core insertion, and high-grade sealant injection.", standard_price: 30.00)
srv_cassette_rep    = Service.create!(name: "Cassette & Cogset Replacement", description: "Freehub body spline inspection, torque-spec lockring mounting, and shift verification.", standard_price: 25.00)
srv_bar_stem_fit    = Service.create!(name: "Handlebar & Stem Replacement / Fitting", description: "Ergonomic cockpit sizing, faceplate torque sequencing, and grip reinstallation.", standard_price: 30.00)
srv_cable_replace   = Service.create!(name: "Cable & Housing Replacement (Brake & Shift)", description: "Low-friction slick cable routing, housing ferrule sealing, and indexing readjustment.", standard_price: 40.00)
srv_dropper_bleed   = Service.create!(name: "Dropper Post Bleed & Cable Installation", description: "Hydraulic remote cartridge bleed and precision actuator cable adjustment.", standard_price: 50.00)
srv_rotor_replace   = Service.create!(name: "Disc Brake Rotor Replacement & Truing", description: "Rotor runout measurement, caliper alignment, and heat burnishing.", standard_price: 25.00)
srv_pedal_repair    = Service.create!(name: "Pedal Thread Repair & Heli-Coil Installation", description: "Crank arm thread cleaning, tap re-threading, and steel insert installation.", standard_price: 35.00)
srv_wheel_build     = Service.create!(name: "Custom Wheel Build (Per Wheel)", description: "Custom lacing, tension calculation with tensiometer, and stress-relieving cycles.", standard_price: 75.00)

# Customers
c1  = Customer.create!(name: "Carlos Silva", phone: "+56 9 8765 4321")
c2  = Customer.create!(name: "Maria Fernandez", phone: "+56 9 7654 3210")
c3  = Customer.create!(name: "Joaquin Perez", phone: "+56 9 6543 2109")
c4  = Customer.create!(name: "Valentina Morales", phone: "+56 9 5432 1098")
c5  = Customer.create!(name: "Diego Ramirez", phone: "+56 9 4321 0987")
c6  = Customer.create!(name: "Camila Soto", phone: "+56 9 3210 9876")
c7  = Customer.create!(name: "Andres Castro", phone: "+56 9 2109 8765")
c8  = Customer.create!(name: "Francisca Lopez", phone: "+56 9 1098 7654")
c9  = Customer.create!(name: "Gabriel Munoz", phone: "+56 9 9988 7766")
c10 = Customer.create!(name: "Isidora Rojas", phone: "+56 9 8877 6655")
c11 = Customer.create!(name: "Pedro Gutierrez", phone: "+56 9 7766 5544")

# Bikes
bike1  = Bike.create!(customer_id: c1.id, make: "Trek", model: "Marlin 7", color: "Matte Nautical Navy", serial_number: "WTU1234567A")
bike2  = Bike.create!(customer_id: c1.id, make: "Trek", model: "Marlin 7", color: "Matte Nautical Navy", serial_number: "WTU7654321B")
bike3  = Bike.create!(customer_id: c2.id, make: "Specialized", model: "Rockhopper Comp", color: "Gloss Red", serial_number: "SN-SP-98213")
bike4  = Bike.create!(customer_id: c3.id, make: "Giant", model: "Escape 3", color: "Charcoal", serial_number: "SN-GI-11452")
bike5  = Bike.create!(customer_id: c4.id, make: "Cannondale", model: "Trail 5", color: "Emerald Green", serial_number: "SN-CD-88741")
bike6  = Bike.create!(customer_id: c5.id, make: "Santa Cruz", model: "Chameleon", color: "Gloss Yellow", serial_number: "SN-SC-33412")
bike7  = Bike.create!(customer_id: c6.id, make: "Scott", model: "Aspect 950", color: "Slate Blue", serial_number: "SN-ST-55678")
bike8  = Bike.create!(customer_id: c7.id, make: "Merida", model: "Big Nine 200", color: "Gloss Black", serial_number: "SN-ME-77890")
bike9  = Bike.create!(customer_id: c8.id, make: "Orbea", model: "Alma H30", color: "Mint Green", serial_number: "SN-OR-22341")
bike10 = Bike.create!(customer_id: c9.id, make: "Bianchi", model: "C-Sport 2", color: "Celeste", serial_number: "SN-BI-99012")
bike11 = Bike.create!(customer_id: c10.id, make: "Kona", model: "Rove AL", color: "Metallic Bronze", serial_number: "SN-KO-44567")
bike12 = Bike.create!(customer_id: c11.id, make: "Marin", model: "Nicasio", color: "Gloss Silver", serial_number: "SN-MA-66789")
bike13 = Bike.create!(customer_id: c3.id, make: "Trek", model: "FX 2 Disc", color: "Lithium Grey", serial_number: "SN-TR-88123")

# Repairs

# New intake waiting for mechanic allocation
r1 = Repair.create!(
  bike_id: bike1.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: nil,
  status: "Received",
  promised_on: 2.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 1.hour.ago
)
RepairItem.create!(repair_id: r1.id, service_id: srv_safety_check.id, charged_price: 25.00, notes: "Initial intake check")

# Inspected and diagnosed, preparing customer estimate
r2 = Repair.create!(
  bike_id: bike3.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Diagnosed",
  promised_on: 3.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 5.hours.ago
)
RepairItem.create!(repair_id: r2.id, service_id: srv_drivetrain_cln.id, charged_price: 50.00, notes: "Heavy mud build-up")
RepairItem.create!(repair_id: r2.id, service_id: srv_chain_replace.id, charged_price: 20.00, notes: "0.75% chain stretch")

# Quoted, called customer and waiting for approval
r3 = Repair.create!(
  bike_id: bike4.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Awaiting Approval",
  promised_on: 2.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairItem.create!(repair_id: r3.id, service_id: srv_brake_bleed.id, charged_price: 45.00, notes: "Rear lever pulling to bar")
RepairItem.create!(repair_id: r3.id, service_id: srv_rotor_replace.id, charged_price: 25.00, notes: "Rotor contaminated with oil")

# Overdue ticket delayed waiting on supplier parts
r4 = Repair.create!(
  bike_id: bike5.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "In Progress",
  promised_on: 3.days.ago.to_date,
  approved_by_customer: true,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 5.days.ago
)
RepairItem.create!(repair_id: r4.id, service_id: srv_fork_service.id, charged_price: 85.00, notes: "Awaiting special dust wiper seals")
RepairItem.create!(repair_id: r4.id, service_id: srv_headset_service.id, charged_price: 35.00, notes: "Crown race cleaning")

# Fast puncture fix completed same day
r5_date = 4.days.ago
r5 = Repair.create!(
  bike_id: bike6.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Completed",
  promised_on: r5_date.to_date,
  approved_by_customer: true,
  completed_at: r5_date.change(hour: 14, min: 0),
  picked_up_at: r5_date.change(hour: 17, min: 30),
  created_at: r5_date.change(hour: 9, min: 15)
)
RepairItem.create!(repair_id: r5.id, service_id: srv_flat_repair.id, charged_price: 15.00, notes: "Thorn in rear tire")

# Customer declined overhaul quote and took bike
r6 = Repair.create!(
  bike_id: bike7.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Declined",
  promised_on: 2.days.ago.to_date,
  approved_by_customer: false,
  completed_at: nil,
  picked_up_at: 1.day.ago,
  created_at: 3.days.ago
)
RepairItem.create!(repair_id: r6.id, service_id: srv_full_overhaul.id, charged_price: 160.00, notes: "Customer declined full overhaul quote")

# First visit for Marlin: initial break-in check
r7 = Repair.create!(
  bike_id: bike2.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "Completed",
  promised_on: 45.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 44.days.ago,
  picked_up_at: 43.days.ago,
  created_at: 46.days.ago
)
RepairItem.create!(repair_id: r7.id, service_id: srv_safety_check.id, charged_price: 25.00, notes: "Initial 30-day tune-up")
RepairItem.create!(repair_id: r7.id, service_id: srv_derailleur_tune.id, charged_price: 35.00, notes: "Cable stretch adjustment")

# Second visit for same bike: tubeless conversion on the ready rack
r8 = Repair.create!(
  bike_id: bike2.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Ready for Pickup",
  promised_on: Date.current,
  approved_by_customer: true,
  completed_at: 2.hours.ago,
  picked_up_at: nil,
  created_at: 2.days.ago
)
RepairItem.create!(repair_id: r8.id, service_id: srv_tubeless_setup.id, charged_price: 30.00, notes: "Converted front and rear to tubeless")
RepairItem.create!(repair_id: r8.id, service_id: srv_wheel_truing.id, charged_price: 30.00, notes: "Bundle discount with tubeless package")

# Historical service from late last year before January price increases
last_year_date = Date.new(Date.current.year - 1, 10, 14)
r9 = Repair.create!(
  bike_id: bike8.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Completed",
  promised_on: last_year_date + 2.days,
  approved_by_customer: true,
  completed_at: (last_year_date + 1.day).to_time.change(hour: 16),
  picked_up_at: (last_year_date + 2.days).to_time.change(hour: 11),
  created_at: last_year_date.to_time.change(hour: 10)
)
RepairItem.create!(repair_id: r9.id, service_id: srv_safety_check.id, charged_price: 18.00, notes: "Pre-2026 labor rate")
RepairItem.create!(repair_id: r9.id, service_id: srv_bb_service.id, charged_price: 32.00, notes: "Pre-2026 labor rate")

# Ongoing cable replacement
r10 = Repair.create!(
  bike_id: bike9.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "In Progress",
  promised_on: 1.day.from_now.to_date,
  approved_by_customer: true,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairItem.create!(repair_id: r10.id, service_id: srv_cable_replace.id, charged_price: 35.00, notes: "Club member discount")
RepairItem.create!(repair_id: r10.id, service_id: srv_brake_adj.id, charged_price: 25.00, notes: "Club member discount")

# Wheel truing complete
r11 = Repair.create!(
  bike_id: bike10.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Ready for Pickup",
  promised_on: Date.current,
  approved_by_customer: true,
  completed_at: 3.hours.ago,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairItem.create!(repair_id: r11.id, service_id: srv_wheel_truing.id, charged_price: 35.00, notes: "Lateral wobble corrected")

# Bar fitting complete
r12 = Repair.create!(
  bike_id: bike11.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Completed",
  promised_on: 6.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 7.days.ago,
  picked_up_at: 6.days.ago,
  created_at: 8.days.ago
)
RepairItem.create!(repair_id: r12.id, service_id: srv_bar_stem_fit.id, charged_price: 30.00, notes: "Customer brought own carbon bar")
RepairItem.create!(repair_id: r12.id, service_id: srv_brake_adj.id, charged_price: 30.00, notes: "Re-aligned levers")

# Intake for rear hub noise
r13 = Repair.create!(
  bike_id: bike13.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: nil,
  status: "Received",
  promised_on: 4.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 2.hours.ago
)
RepairItem.create!(repair_id: r13.id, service_id: srv_hub_overhaul.id, charged_price: 40.00, notes: "Bearing friction in freehub")

# Pedal thread repair
r14 = Repair.create!(
  bike_id: bike4.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "Diagnosed",
  promised_on: 3.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 6.hours.ago
)
RepairItem.create!(repair_id: r14.id, service_id: srv_pedal_repair.id, charged_price: 35.00, notes: "Non-drive side thread stripped")
RepairItem.create!(repair_id: r14.id, service_id: srv_dropper_bleed.id, charged_price: 50.00, notes: "Slow return action")

# Full drivetrain service
r15 = Repair.create!(
  bike_id: bike3.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Completed",
  promised_on: 12.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 13.days.ago,
  picked_up_at: 12.days.ago,
  created_at: 15.days.ago
)
RepairItem.create!(repair_id: r15.id, service_id: srv_cassette_rep.id, charged_price: 25.00, notes: "Sunrace 11-34T")
RepairItem.create!(repair_id: r15.id, service_id: srv_chain_replace.id, charged_price: 20.00, notes: "KMC X9 chain")
RepairItem.create!(repair_id: r15.id, service_id: srv_derailleur_tune.id, charged_price: 35.00, notes: "Hanger was slightly bent")
RepairItem.create!(repair_id: r15.id, service_id: srv_drivetrain_cln.id, charged_price: 45.00, notes: "Multi-service package discount")

# Custom wheel build
r16 = Repair.create!(
  bike_id: bike6.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Completed",
  promised_on: 20.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 21.days.ago,
  picked_up_at: 20.days.ago,
  created_at: 25.days.ago
)
RepairItem.create!(repair_id: r16.id, service_id: srv_wheel_build.id, charged_price: 75.00, notes: "Hope Pro 4 hub on Stans Flow rim")
RepairItem.create!(repair_id: r16.id, service_id: srv_tubeless_setup.id, charged_price: 25.00, notes: "Tape and valve with wheel build")

puts "Done. Seeded #{Service.count} services, #{StaffMember.count} staff, #{Customer.count} customers, #{Bike.count} bikes, and #{Repair.count} repairs (#{RepairItem.count} items)."
