require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  context 'Success Path - It is a valid token' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)      
      payload = {
        user_id: @current_user.id.to_s,
        expiration_date: (ActiveSupport::TimeZone[-3].now+1.day).strftime('%Y-%m-%d %H:%M')
      }
      token = JWT.encode payload, nil, 'none'

      params = {token: token}
      post api_v1_auth_verify_token_path, params: params, as: :json
    end

    it 'should have status 200' do
      expect(response).to have_http_status(200)
    end

    it 'should contain a message' do
      expect(json_response).to have_key(:message)
      expect(json_response.dig(:message)).to eq(I18n.t('token.decode.valid'))
    end

    it 'should be valid' do
      expect(json_response.dig(:is_valid)).to be_truthy
    end
  end

  context 'Failure - Expired Token' do
    before(:all) do
      @current_user = FactoryBot.create(:user_001)      
      payload = {
        user_id: @current_user.id.to_s,
        expiration_date: (ActiveSupport::TimeZone[-3].now-1.day).strftime('%Y-%m-%d %H:%M')
      }
      token = JWT.encode payload, nil, 'none'

      params = {token: token}
      post api_v1_auth_verify_token_path, params: params, as: :json
    end

    it 'should have status 401' do
      expect(response).to have_http_status(401)
    end

    it 'should be not valid' do
      expect(json_response.dig(:is_valid)).to be_falsy
    end
  end

  context 'Failure - Sending an random invalid Token' do
    before(:all) do
      params = {token: 'ascapsikchakscljbaclajbclkacbalksj'}
      post api_v1_auth_verify_token_path, params: params, as: :json
    end

    it 'should have status 401' do
      expect(response).to have_http_status(401)
    end

    it 'should be not valid' do
      expect(json_response.dig(:is_valid)).to be_falsy
    end
  end

  context 'Failure - Missing Params' do
    before(:all) do
      # params = {email: @current_user.email, password: 'pass@1915'}
      post api_v1_auth_verify_token_path, as: :json
    end

    it 'should have status 400' do
      expect(response).to have_http_status(400)
    end

    it 'should have a message' do
      expect(json_response).to have_key(:message)
      expect(json_response.dig(:message)).to eq(I18n.t('params.invalid'))
    end

    it 'should be not valid' do
      expect(json_response.dig(:is_valid)).to be_falsy
    end
  end
end
