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
    current_page?(settings_path)
  end

  def is_teams_path_active?
    if @team.nil?
      current_page?(teams_path)
    elsif @team.persisted?
      current_page?(team_path(@team)) || current_page?(edit_team_path(@team)) || current_page?(my_team_path) || current_page?(edit_my_team_path)
    else
      false
    end
  end

  def is_companies_path_active?
    if @company.nil?
      current_page?(companies_path)
    elsif @company.persisted?
      current_page?(company_path(@company)) || current_page?(edit_company_path(@company)) || current_page?(my_company_path) || current_page?(edit_my_company_path)
    else
      false
    end
  end

  def is_users_path_active?
    current_page?(edit_my_user_path) || current_page?(users_path) if !current_user.nil?
  end

  def title(text)
    content_for :title, text
  end

  def default_address
    "Fred. Roeskestraat 115, 1076 EE Amsterdam, Netherlands"
  end
end
