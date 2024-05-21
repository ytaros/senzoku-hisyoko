# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :home_authorize

  def index; end

  private

  def home_authorize
    authorize :home
  end
end
