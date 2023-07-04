require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  context 'Sucess Path' do
    before(:all) do
      #Creating 50 users
      for i in 0..49 do
        FactoryBot.create(:user_001)
      end

      #Creating user of authentication
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      get api_v1_users_path, headers: headers
      @response = JSON.parse(response.body)
    end

    it 'Should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'Should return the fields of the user' do
      expect(@response).to have_key('total_items')
      expect(@response).to have_key('total_pages')
      expect(@response).to have_key('page')
      expect(@response).to have_key('previous_page')
      expect(@response).to have_key('next_page')
      expect(@response).to have_key('results')
      expect(@response&.dig('results')).to be_a(Array)

      @response&.dig('results')&.each do |item|
        expect(item).to have_key('id')
        expect(item).to have_key('name')
        expect(item).to have_key('email')
        expect(item).to have_key('is_blocked')
        expect(item).to have_key('registered_at')
      end
    end
  end

end
