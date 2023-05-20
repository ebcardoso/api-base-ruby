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
      get api_v1_profile_my_user_path, headers: headers, as: :json
      binding.pry
    end

    it 'Should have status 200' do
      expect(response).to have_http_status(200)
    end
  end
end

