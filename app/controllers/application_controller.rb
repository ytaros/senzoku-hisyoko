# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pundit::Authorization
  include Pagy::Backend
  after_action :verify_authorized
  before_action :logged_in_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:danger] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_back(fallback_location: root_path)
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t('please_login')
    redirect_to login_url, status: :see_other
  end
end
