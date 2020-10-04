class AdminhomesController < ApplicationController
  before_action :admin_role_required, only: %i[adhome]

  # adhome

  def adhome
    @admin_home_page = User.admin_home_page_report
    json_response(@admin_home_page)
  end

  private

  def admin_role_required
    return if current_user['role'] == 'admin'

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end
end
