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
    current_page?(new_delivery_path) || current_page?(authenticated_root_path)
  end

  def is_settings_path_active?
    current_page?(edit_user_registration_path)
  end

  def is_teams_path_active?
    if @team.nil?
      current_page?(teams_path)
    elsif @team.persisted?
      current_page?(team_path(@team)) || current_page?(edit_team_path(@team))
    else
      false
    end
  end

  def is_companies_path_active?
    if @company.nil?
      current_page?(companies_path)
    elsif @company.persisted?
      current_page?(company_path(@company)) || current_page?(edit_company_path(@company))
    else
      false
    end
  end

  def title(text)
    content_for :title, text
  end
end
