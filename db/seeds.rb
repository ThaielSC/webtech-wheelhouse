RepairItem.destroy_all
Repair.destroy_all
Bike.destroy_all
Customer.destroy_all
StaffMember.destroy_all
Service.destroy_all

puts "Seeding Wheelhouse database..."

lucas = StaffMember.create!(name: "Lucas Morales", role: "Counter Staff")
elena = StaffMember.create!(name: "Elena Rostova", role: "Mechanic")
mateo = StaffMember.create!(name: "Mateo Valenzuela", role: "Mechanic")
sofia = StaffMember.create!(name: "Sofia Alarcon", role: "Mechanic")

safety_check = Service.create!(name: "Safety Check & Inspection", description: "Comprehensive safety inspection of frame, brakes, drivetrain, and torque settings.", standard_price: 25.00)
flat_tire_repair = Service.create!(name: "Flat Tire Repair / Tube Replacement", description: "Puncture inspection, rim tape check, and new tube installation.", standard_price: 15.00)
brake_adjustment = Service.create!(name: "Brake Adjustment (Front & Rear)", description: "Cable tension calibration, pad alignment, and rotor/rim cleaning.", standard_price: 30.00)
brake_bleed = Service.create!(name: "Hydraulic Brake Bleed", description: "Complete fluid flush, air bubble removal, and lever feel restoration per brake.", standard_price: 45.00)
derailleur_tune = Service.create!(name: "Derailleur & Shifting Tune-up", description: "Limit screw setup, cable tension adjustment, and derailleur hanger alignment.", standard_price: 35.00)
drivetrain_cleaning = Service.create!(name: "Drivetrain Deep Clean & Lubrication", description: "Degreasing and ultrasonic cleaning of chain, cassette, and chainrings with fresh lube.", standard_price: 50.00)
chain_replacement = Service.create!(name: "Chain Replacement & Sizing", description: "Chain wear inspection, precision link sizing, and new chain installation.", standard_price: 20.00)
wheel_truing = Service.create!(name: "Wheel Truing", description: "Spoke tension balancing, lateral and radial wheel straightening on the truing stand.", standard_price: 35.00)
bottom_bracket_service = Service.create!(name: "Bottom Bracket Service / Replacement", description: "Crankset removal, shell inspection, bottom bracket overhaul or replacement.", standard_price: 40.00)
headset_service = Service.create!(name: "Headset Overhaul & Adjustment", description: "Steerer inspection, bearing cleaning/regreasing, and proper preload adjustment.", standard_price: 35.00)
hub_overhaul = Service.create!(name: "Wheel Hub Bearing Overhaul", description: "Axle disassembly, cone adjustment, bearing replacement, and marine-grade grease pack.", standard_price: 40.00)
full_overhaul = Service.create!(name: "Full Workshop Overhaul", description: "Complete bike strip-down, deep clean, bearing service, cable replacement, and road test.", standard_price: 160.00)
fork_service = Service.create!(name: "Fork & Suspension Air Spring Service", description: "Lower leg inspection, wiper seal replacement, bath oil refresh, and pressure setup.", standard_price: 85.00)
tubeless_setup = Service.create!(name: "Tubeless Tire Setup & Sealant Injection", description: "Tubeless rim tape installation, valve core insertion, and high-grade sealant injection.", standard_price: 30.00)
cassette_replacement = Service.create!(name: "Cassette & Cogset Replacement", description: "Freehub body spline inspection, torque-spec lockring mounting, and shift verification.", standard_price: 25.00)
handlebar_stem_fitting = Service.create!(name: "Handlebar & Stem Replacement / Fitting", description: "Ergonomic cockpit sizing, faceplate torque sequencing, and grip reinstallation.", standard_price: 30.00)
cable_replacement = Service.create!(name: "Cable & Housing Replacement (Brake & Shift)", description: "Low-friction slick cable routing, housing ferrule sealing, and indexing readjustment.", standard_price: 40.00)
dropper_bleed = Service.create!(name: "Dropper Post Bleed & Cable Installation", description: "Hydraulic remote cartridge bleed and precision actuator cable adjustment.", standard_price: 50.00)
rotor_replacement = Service.create!(name: "Disc Brake Rotor Replacement & Truing", description: "Rotor runout measurement, caliper alignment, and heat burnishing.", standard_price: 25.00)
pedal_thread_repair = Service.create!(name: "Pedal Thread Repair & Heli-Coil Installation", description: "Crank arm thread cleaning, tap re-threading, and steel insert installation.", standard_price: 35.00)
custom_wheel_build = Service.create!(name: "Custom Wheel Build (Per Wheel)", description: "Custom lacing, tension calculation with tensiometer, and stress-relieving cycles.", standard_price: 75.00)

carlos = Customer.create!(name: "Carlos Silva", phone: "+56 9 8765 4321")
maria = Customer.create!(name: "Maria Fernandez", phone: "+56 9 7654 3210")
joaquin = Customer.create!(name: "Joaquin Perez", phone: "+56 9 6543 2109")
valentina = Customer.create!(name: "Valentina Morales", phone: "+56 9 5432 1098")
diego = Customer.create!(name: "Diego Ramirez", phone: "+56 9 4321 0987")
camila = Customer.create!(name: "Camila Soto", phone: "+56 9 3210 9876")
andres = Customer.create!(name: "Andres Castro", phone: "+56 9 2109 8765")
francisca = Customer.create!(name: "Francisca Lopez", phone: "+56 9 1098 7654")
gabriel = Customer.create!(name: "Gabriel Munoz", phone: "+56 9 9988 7766")
isidora = Customer.create!(name: "Isidora Rojas", phone: "+56 9 8877 6655")
pedro = Customer.create!(name: "Pedro Gutierrez", phone: "+56 9 7766 5544")

carlos_marlin = Bike.create!(customer_id: carlos.id, make: "Trek", model: "Marlin 7", color: "Matte Nautical Navy", serial_number: "WTU1234567A")
carlos_second_marlin = Bike.create!(customer_id: carlos.id, make: "Trek", model: "Marlin 7", color: "Matte Nautical Navy", serial_number: "WTU7654321B")
maria_rockhopper = Bike.create!(customer_id: maria.id, make: "Specialized", model: "Rockhopper Comp", color: "Gloss Red", serial_number: "SN-SP-98213")
joaquin_escape = Bike.create!(customer_id: joaquin.id, make: "Giant", model: "Escape 3", color: "Charcoal", serial_number: "SN-GI-11452")
valentina_trail = Bike.create!(customer_id: valentina.id, make: "Cannondale", model: "Trail 5", color: "Emerald Green", serial_number: "SN-CD-88741")
diego_chameleon = Bike.create!(customer_id: diego.id, make: "Santa Cruz", model: "Chameleon", color: "Gloss Yellow", serial_number: "SN-SC-33412")
camila_aspect = Bike.create!(customer_id: camila.id, make: "Scott", model: "Aspect 950", color: "Slate Blue", serial_number: "SN-ST-55678")
andres_big_nine = Bike.create!(customer_id: andres.id, make: "Merida", model: "Big Nine 200", color: "Gloss Black", serial_number: "SN-ME-77890")
francisca_alma = Bike.create!(customer_id: francisca.id, make: "Orbea", model: "Alma H30", color: "Mint Green", serial_number: "SN-OR-22341")
gabriel_c_sport = Bike.create!(customer_id: gabriel.id, make: "Bianchi", model: "C-Sport 2", color: "Celeste", serial_number: "SN-BI-99012")
isidora_rove = Bike.create!(customer_id: isidora.id, make: "Kona", model: "Rove AL", color: "Metallic Bronze", serial_number: "SN-KO-44567")
pedro_nicasio = Bike.create!(customer_id: pedro.id, make: "Marin", model: "Nicasio", color: "Gloss Silver", serial_number: "SN-MA-66789")
joaquin_fx = Bike.create!(customer_id: joaquin.id, make: "Trek", model: "FX 2 Disc", color: "Lithium Grey", serial_number: "SN-TR-88123")


received_marlin_repair = Repair.create!(
  bike_id: carlos_marlin.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: nil,
  status: "Received",
  promised_on: 2.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 1.hour.ago
)
RepairItem.create!(repair_id: received_marlin_repair.id, service_id: safety_check.id, charged_price: 25.00, notes: "Initial intake check")

diagnosed_rockhopper_repair = Repair.create!(
  bike_id: maria_rockhopper.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Diagnosed",
  promised_on: 3.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 5.hours.ago
)
RepairItem.create!(repair_id: diagnosed_rockhopper_repair.id, service_id: drivetrain_cleaning.id, charged_price: 50.00, notes: "Heavy mud build-up")
RepairItem.create!(repair_id: diagnosed_rockhopper_repair.id, service_id: chain_replacement.id, charged_price: 20.00, notes: "0.75% chain stretch")

awaiting_approval_escape_repair = Repair.create!(
  bike_id: joaquin_escape.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Awaiting Approval",
  promised_on: 2.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairItem.create!(repair_id: awaiting_approval_escape_repair.id, service_id: brake_bleed.id, charged_price: 45.00, notes: "Rear lever pulling to bar")
RepairItem.create!(repair_id: awaiting_approval_escape_repair.id, service_id: rotor_replacement.id, charged_price: 25.00, notes: "Rotor contaminated with oil")

overdue_trail_repair = Repair.create!(
  bike_id: valentina_trail.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "In Progress",
  promised_on: 3.days.ago.to_date,
  approved_by_customer: true,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 5.days.ago
)
RepairItem.create!(repair_id: overdue_trail_repair.id, service_id: fork_service.id, charged_price: 85.00, notes: "Awaiting special dust wiper seals")
RepairItem.create!(repair_id: overdue_trail_repair.id, service_id: headset_service.id, charged_price: 35.00, notes: "Crown race cleaning")

chameleon_repair_date = 4.days.ago
completed_chameleon_repair = Repair.create!(
  bike_id: diego_chameleon.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Completed",
  promised_on: chameleon_repair_date.to_date,
  approved_by_customer: true,
  completed_at: chameleon_repair_date.change(hour: 14, min: 0),
  picked_up_at: chameleon_repair_date.change(hour: 17, min: 30),
  created_at: chameleon_repair_date.change(hour: 9, min: 15)
)
RepairItem.create!(repair_id: completed_chameleon_repair.id, service_id: flat_tire_repair.id, charged_price: 15.00, notes: "Thorn in rear tire")

declined_aspect_repair = Repair.create!(
  bike_id: camila_aspect.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Declined",
  promised_on: 2.days.ago.to_date,
  approved_by_customer: false,
  completed_at: nil,
  picked_up_at: 1.day.ago,
  created_at: 3.days.ago
)
RepairItem.create!(repair_id: declined_aspect_repair.id, service_id: full_overhaul.id, charged_price: 160.00, notes: "Customer declined full overhaul quote")

previous_marlin_repair = Repair.create!(
  bike_id: carlos_second_marlin.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "Completed",
  promised_on: 45.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 44.days.ago,
  picked_up_at: 43.days.ago,
  created_at: 46.days.ago
)
RepairItem.create!(repair_id: previous_marlin_repair.id, service_id: safety_check.id, charged_price: 25.00, notes: "Initial 30-day tune-up")
RepairItem.create!(repair_id: previous_marlin_repair.id, service_id: derailleur_tune.id, charged_price: 35.00, notes: "Cable stretch adjustment")

ready_marlin_repair = Repair.create!(
  bike_id: carlos_second_marlin.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Ready for Pickup",
  promised_on: Date.current,
  approved_by_customer: true,
  completed_at: 2.hours.ago,
  picked_up_at: nil,
  created_at: 2.days.ago
)
RepairItem.create!(repair_id: ready_marlin_repair.id, service_id: tubeless_setup.id, charged_price: 30.00, notes: "Converted front and rear to tubeless")
RepairItem.create!(repair_id: ready_marlin_repair.id, service_id: wheel_truing.id, charged_price: 30.00, notes: "Bundle discount with tubeless package")

last_year_date = Date.new(Date.current.year - 1, 10, 14)
last_year_big_nine_repair = Repair.create!(
  bike_id: andres_big_nine.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Completed",
  promised_on: last_year_date + 2.days,
  approved_by_customer: true,
  completed_at: (last_year_date + 1.day).to_time.change(hour: 16),
  picked_up_at: (last_year_date + 2.days).to_time.change(hour: 11),
  created_at: last_year_date.to_time.change(hour: 10)
)
RepairItem.create!(repair_id: last_year_big_nine_repair.id, service_id: safety_check.id, charged_price: 18.00, notes: "Pre-2026 labor rate")
RepairItem.create!(repair_id: last_year_big_nine_repair.id, service_id: bottom_bracket_service.id, charged_price: 32.00, notes: "Pre-2026 labor rate")

in_progress_alma_repair = Repair.create!(
  bike_id: francisca_alma.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "In Progress",
  promised_on: 1.day.from_now.to_date,
  approved_by_customer: true,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairItem.create!(repair_id: in_progress_alma_repair.id, service_id: cable_replacement.id, charged_price: 35.00, notes: "Club member discount")
RepairItem.create!(repair_id: in_progress_alma_repair.id, service_id: brake_adjustment.id, charged_price: 25.00, notes: "Club member discount")

ready_c_sport_repair = Repair.create!(
  bike_id: gabriel_c_sport.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Ready for Pickup",
  promised_on: Date.current,
  approved_by_customer: true,
  completed_at: 3.hours.ago,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairItem.create!(repair_id: ready_c_sport_repair.id, service_id: wheel_truing.id, charged_price: 35.00, notes: "Lateral wobble corrected")

completed_rove_repair = Repair.create!(
  bike_id: isidora_rove.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Completed",
  promised_on: 6.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 7.days.ago,
  picked_up_at: 6.days.ago,
  created_at: 8.days.ago
)
RepairItem.create!(repair_id: completed_rove_repair.id, service_id: handlebar_stem_fitting.id, charged_price: 30.00, notes: "Customer brought own carbon bar")
RepairItem.create!(repair_id: completed_rove_repair.id, service_id: brake_adjustment.id, charged_price: 30.00, notes: "Re-aligned levers")

received_fx_repair = Repair.create!(
  bike_id: joaquin_fx.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: nil,
  status: "Received",
  promised_on: 4.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 2.hours.ago
)
RepairItem.create!(repair_id: received_fx_repair.id, service_id: hub_overhaul.id, charged_price: 40.00, notes: "Bearing friction in freehub")

diagnosed_escape_repair = Repair.create!(
  bike_id: joaquin_escape.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: sofia.id,
  status: "Diagnosed",
  promised_on: 3.days.from_now.to_date,
  approved_by_customer: nil,
  completed_at: nil,
  picked_up_at: nil,
  created_at: 6.hours.ago
)
RepairItem.create!(repair_id: diagnosed_escape_repair.id, service_id: pedal_thread_repair.id, charged_price: 35.00, notes: "Non-drive side thread stripped")
RepairItem.create!(repair_id: diagnosed_escape_repair.id, service_id: dropper_bleed.id, charged_price: 50.00, notes: "Slow return action")

completed_rockhopper_repair = Repair.create!(
  bike_id: maria_rockhopper.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: elena.id,
  status: "Completed",
  promised_on: 12.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 13.days.ago,
  picked_up_at: 12.days.ago,
  created_at: 15.days.ago
)
RepairItem.create!(repair_id: completed_rockhopper_repair.id, service_id: cassette_replacement.id, charged_price: 25.00, notes: "Sunrace 11-34T")
RepairItem.create!(repair_id: completed_rockhopper_repair.id, service_id: chain_replacement.id, charged_price: 20.00, notes: "KMC X9 chain")
RepairItem.create!(repair_id: completed_rockhopper_repair.id, service_id: derailleur_tune.id, charged_price: 35.00, notes: "Hanger was slightly bent")
RepairItem.create!(repair_id: completed_rockhopper_repair.id, service_id: drivetrain_cleaning.id, charged_price: 45.00, notes: "Multi-service package discount")

completed_custom_wheel_repair = Repair.create!(
  bike_id: diego_chameleon.id,
  intake_by_staff_id: lucas.id,
  assigned_mechanic_id: mateo.id,
  status: "Completed",
  promised_on: 20.days.ago.to_date,
  approved_by_customer: true,
  completed_at: 21.days.ago,
  picked_up_at: 20.days.ago,
  created_at: 25.days.ago
)
RepairItem.create!(repair_id: completed_custom_wheel_repair.id, service_id: custom_wheel_build.id, charged_price: 75.00, notes: "Hope Pro 4 hub on Stans Flow rim")
RepairItem.create!(repair_id: completed_custom_wheel_repair.id, service_id: tubeless_setup.id, charged_price: 25.00, notes: "Tape and valve with wheel build")

puts "Done. Seeded #{Service.count} services, #{StaffMember.count} staff, #{Customer.count} customers, #{Bike.count} bikes, and #{Repair.count} repairs (#{RepairItem.count} items)."
