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

  def form_field_class(record, attribute, base_class = "form-control")
    class_names(base_class, "is-invalid" => record.errors[attribute].any?)
  end

  def repair_status_options
    Repair.statuses.map { |status, label| [label, status] }
  end

  def bike_option_label(bike)
    "#{bike.serial_number} — #{bike_name(bike)} (#{bike.customer.name})"
  end
end
