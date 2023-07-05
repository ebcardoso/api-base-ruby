require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  context 'Sucess Path' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }
      @user_blocked = FactoryBot.create(:user_002)
      patch unlock_user_api_v1_users_path(@user_blocked.id.to_s), headers: headers
      @response = JSON.parse(response.body)
    end

    it 'Should have blocked flag equals false' do
      @user_blocked.reload
      expect(@user_blocked.is_blocked).to be_falsey
    end

    it 'Should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'Should have a message' do
      expect(@response).to have_key('message')
      expect(@response&.dig('message')).to eq(I18n.t('user.unlock.success'))
    end
  end

  context 'Failure - User not Found' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }
      patch unlock_user_api_v1_users_path('1235'), headers: headers
      @response = JSON.parse(response.body)
    end

    it 'Should return status 404' do
      expect(response).to have_http_status(404)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
      expect(@response&.dig('message')).to eq(I18n.t('user.errors.not_found'))
    end
  end
end
