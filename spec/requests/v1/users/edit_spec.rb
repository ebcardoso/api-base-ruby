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
      @params = {
        name: 'Name Changed',
        email: 'user@email.com'
      }
      patch api_v1_user_path(@current_user.id.to_s), headers: headers, params: @params
      @response = JSON.parse(response.body)
    end

    it 'Should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'Should return the fields of the user' do
      expect(@response).to have_key('id')
      expect(@response).to have_key('name')
      expect(@response).to have_key('email')
      expect(@response).to have_key('registered_at')
    end

    it 'Should match the values' do
      expect(@response&.dig('name')).to eq(@params.dig(:name))
      expect(@response&.dig('email')).to eq(@params.dig(:email))
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
      patch api_v1_user_path('1235'), headers: headers
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
