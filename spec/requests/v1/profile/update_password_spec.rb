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
      params = {
        current_password: 'pass@1915',
        password: '123456',
        password_confirmation: '123456'
      }
      post api_v1_profile_update_password_path, headers: headers, params: params, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(200)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.update_password.success'))
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
      post api_v1_profile_update_password_path, headers: headers, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
    end
  end

  context 'Failure - Insufficient characters' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params, as: :json

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      params = {
        current_password: 'pass@1915',
        confirmation: '123',
        password_confirmation: '123'
      }
      post api_v1_profile_update_password_path, headers: headers, params: params, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
    end
  end

  context 'Failure - Current password is wrong' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params, as: :json

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      params = {
        current_password: 'pass@cvcv',
        password: '123456',
        password_confirmation: '123abc'
      }
      post api_v1_profile_update_password_path, headers: headers, params: params, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 403' do
      expect(response).to have_http_status(403)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
    end
  end

  context 'Failure - Password and confirmation are different' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_signin_path, params: params, as: :json

      headers = {
        'Authorization': "Bearer #{json_response.dig(:content, :access)}"
      }      
      params = {
        current_password: 'pass@1915',
        password: '123456',
        password_confirmation: '123abc'
      }
      post api_v1_profile_update_password_path, headers: headers, params: params, as: :json
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'Should return a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.registration.errors.password_different'))
    end
  end
end
