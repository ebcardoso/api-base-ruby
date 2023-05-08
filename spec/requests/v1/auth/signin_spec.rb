require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  context 'Success Path' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params, as: :json
    end

    it 'should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return a message and a content' do
      expect(json_response).to have_key(:message)
      expect(json_response.dig(:message)).to eq(I18n.t('user.signin.success'))

      expect(json_response).to have_key(:content)
      expect(json_response.dig(:content)).to have_key(:access)
    end
  end

  context 'Failure Path - Missing Param' do
    before(:all) do
      post api_v1_auth_signin_path, as: :json
    end

    it 'should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'should return a message and content' do
      expect(json_response).to have_key(:message)
      expect(json_response).to have_key(:content)
    end
  end

  context 'Failure Path - Wrong Password' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'wrong-password'}
      post api_v1_auth_signin_path, params: params, as: :json
    end

    it 'should return status 401' do
      expect(response).to have_http_status(401)
    end
  end
end
