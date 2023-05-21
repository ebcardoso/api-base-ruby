require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  context 'Success Path' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email}

      post api_v1_auth_forgot_password_token_path, params: params
      @response = JSON.parse(response.body)
    end

    it 'Should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'Should return a success message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.forgot_password.success'))
    end
  end
  
  context 'Failure Path - Missing Params' do
    before(:all) do
      post api_v1_auth_forgot_password_token_path
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'should countain a message' do
      expect(@response).to have_key('message')
    end
  end

  context 'Failure Path - User not Found' do
    before(:all) do
      params = {email: 'random.user@email.com'}
      post api_v1_auth_forgot_password_token_path, params: params
      @response = JSON.parse(response.body)
    end

    it 'Should return status 404' do
      expect(response).to have_http_status(404)
    end

    it 'should countain a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.errors.not_found'))
    end
  end
end
