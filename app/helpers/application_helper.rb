module ApplicationHelper
  def active_nav_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def is_deliveries_path_active?
    current_page?(deliveries_path) || (@delivery && current_page?(delivery_path(@delivery))) || (@delivery && current_page?(edit_delivery_path(@delivery)))
  end
      
end
