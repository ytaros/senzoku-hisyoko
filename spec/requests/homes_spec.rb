# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do

  before { login(user) }

  describe 'with admin ' do
    let(:user) { create(:admin) }

    describe 'GET /index' do
      it 'ホーム画面に遷移できる' do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'with user ' do
    let(:user) { create(:user) }

    describe 'GET /index' do
      it 'ホーム画面に遷移できる' do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
