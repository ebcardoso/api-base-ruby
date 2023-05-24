require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  context 'Success Path - Password Changed.' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)

      params = {
        token: '12c45f',
        password: '123456msc',
        password_confirmation: '123456msc'
      }
      post api_v1_auth_reset_password_confirm_path, params: params
      @current_user.reload
      @response = JSON.parse(response.body)
    end

    it 'Should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'should contain a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.reset_password.success'))
    end

    it 'should match the new password' do
      expect(@current_user.authenticate('123456msc')).to be_truthy
    end

    it 'should nullify the token' do
      expect(@current_user.token_password_recovery).to be_nil
      expect(@current_user.token_password_recovery_deadline).to be_nil
    end
  end
  
  context 'Failure Path - Missing Params.' do
    before(:all) do
      post api_v1_auth_reset_password_confirm_path
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'should contain a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('params.invalid'))
    end
  end

  context 'Failure Path - Passwords are different.' do
    before(:all) do
      params = {
        token: '12345f',
        password: '123456',
        password_confirmation: '123654'
      }
      post api_v1_auth_reset_password_confirm_path, params: params
      @response = JSON.parse(response.body)
    end

    it 'Should return status 400' do
      expect(response).to have_http_status(400)
    end

    it 'should contain a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.registration.errors.password_different'))
    end
  end

  context 'Failure Path - User not found.' do
    before(:all) do
      params = {
        token: '12345f',
        password: '123456',
        password_confirmation: '123456'
      }
      post api_v1_auth_reset_password_confirm_path, params: params
      @response = JSON.parse(response.body)
    end

    it 'Should return status 404' do
      expect(response).to have_http_status(404)
    end

    it 'should contain a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.errors.not_found'))
    end
  end

  context 'Failure Path - Expired Token.' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)
      @current_user.token_password_recovery_deadline = ActiveSupport::TimeZone[-3].now-1.minute
      @current_user.save

      params = {
        token: '12c45f',
        password: '123456',
        password_confirmation: '123456'
      }
      post api_v1_auth_reset_password_confirm_path, params: params
      @response = JSON.parse(response.body)
    end

    it 'Should return status 422' do
      expect(response).to have_http_status(422)
    end

    it 'should contain a message' do
      expect(@response).to have_key('message')
      expect(@response.dig('message')).to eq(I18n.t('user.reset_password.errors.deadline'))
    end
  end
end
