require 'rails_helper'

RSpec.describe Api::V1::ProfileController, type: :request do
  context 'Success Path' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params, as: :json

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      @params = {
        name: 'Kimi Raikkonen'
      }
      post api_v1_profile_update_profile_path, headers: headers, params: @params, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'Should return the fields' do
      expect(@response).to have_key('id')
      expect(@response).to have_key('name')
      expect(@response).to have_key('email')
    end
  end

  context 'Failure - Missing Params' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params, as: :json

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      post api_v1_profile_update_profile_path, headers: headers, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
      expect(@response&.dig('message')).to eq(I18n.t('params.invalid'))
    end
  end
end
