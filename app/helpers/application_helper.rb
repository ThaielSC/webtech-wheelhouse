module ApplicationHelper
  def money(amount)
    number_to_currency(amount)
  end

  def day(date)
    date&.strftime("%B %-d, %Y") || "—"
  end

  def instant(time)
    time&.strftime("%B %-d, %Y at %-l:%M %p") || "—"
  end

  def bike_name(bike)
    return "" unless bike
    "#{bike.make} #{bike.model}"
  end

  def repair_name(repair)
    return "" unless repair
    "Repair ##{repair.id}"
  end

  def overdue_repair?(repair)
    repair.promised_on.present? && repair.promised_on < Date.current && repair.picked_up_at.nil?
  end
end
