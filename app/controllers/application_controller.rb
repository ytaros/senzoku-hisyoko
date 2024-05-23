# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pundit::Authorization
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_back(fallback_location: root_path)
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t('please_log_in')
    redirect_to login_url, status: :see_other
  end
end
