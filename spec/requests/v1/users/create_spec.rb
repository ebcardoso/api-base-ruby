require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  context 'Success Path' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params

      @headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      } 
      @params = {
        name: Faker::Name.name,
        email: Faker::Internet.email
      }
      post api_v1_users_path, headers: @headers, params: @params
      @response = JSON.parse(response.body)
    end

    it 'should return status 200' do
      expect(response).to have_http_status(200)
    end

    it "should contain the fields of the user on output" do
      expect(@response).to have_key('id')
      expect(@response).to have_key('name')
      expect(@response).to have_key('email')
      expect(@response).to have_key('registered_at')
    end

    it 'should match the values' do
      expect(@response&.dig('name')).to eq(@params.dig(:name))
      expect(@response&.dig('email')).to eq(@params.dig(:email))
    end
  end

  context 'Failure - Missing Params' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      post api_v1_users_path, headers: headers
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
    end
  end

  context 'Failure - Name with less than 6 characters' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params

      @headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      } 
      @params = {
        name: 'Max',
        email: Faker::Internet.email
      }
      post api_v1_users_path, headers: @headers, params: @params
      @response = JSON.parse(response.body)
    end

    it 'should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'should contain :message and :content on output' do
      expect(@response).to have_key('message')
      expect(@response&.dig('message')).to eq(I18n.t('params.invalid'))
    end
  end
end
