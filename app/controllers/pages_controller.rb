class PagesController < ApplicationController
  def home
  end

  def about
  end

  def services
    @services = [
      { name: "Safety Check & Inspection", description: "Comprehensive safety inspection of frame, brakes, drivetrain, and torque settings.", price: 25 },
      { name: "Flat Tire Repair / Tube Replacement", description: "Puncture inspection, rim tape check, and new tube installation.", price: 15 },
      { name: "Brake Adjustment (Front & Rear)", description: "Cable tension calibration, pad alignment, and rotor/rim cleaning.", price: 30 },
      { name: "Hydraulic Brake Bleed", description: "Complete fluid flush, air bubble removal, and lever feel restoration per brake.", price: 45 },
      { name: "Derailleur & Shifting Tune-up", description: "Limit screw setup, cable tension adjustment, and derailleur hanger alignment.", price: 35 },
      { name: "Drivetrain Deep Clean & Lubrication", description: "Degreasing and ultrasonic cleaning of chain, cassette, and chainrings with fresh lube.", price: 50 },
      { name: "Chain Replacement & Sizing", description: "Chain wear inspection, precision link sizing, and new chain installation.", price: 20 },
      { name: "Wheel Truing", description: "Spoke tension balancing, lateral and radial wheel straightening on the truing stand.", price: 35 },
      { name: "Bottom Bracket Service / Replacement", description: "Crankset removal, shell inspection, bottom bracket overhaul or replacement.", price: 40 },
      { name: "Headset Overhaul & Adjustment", description: "Steerer inspection, bearing cleaning/regreasing, and proper preload adjustment.", price: 35 },
      { name: "Wheel Hub Bearing Overhaul", description: "Axle disassembly, cone adjustment, bearing replacement, and marine-grade grease pack.", price: 40 },
      { name: "Full Workshop Overhaul", description: "Complete bike strip-down, deep clean, bearing service, cable replacement, and road test.", price: 160 }
    ]
  end

  def workshop
  end
  
end
