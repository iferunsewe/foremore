module ApplicationHelper
  def is_deliveries_path_active?
    if @delivery.nil?
      current_page?(deliveries_path)
    elsif @delivery.persisted?
      current_page?(delivery_path(@delivery)) || current_page?(edit_delivery_path(@delivery))
    else
      false
    end
  end

  def is_new_deliveries_path_active?
    current_page?(new_delivery_path) || current_page?(root_path)
  end
end
