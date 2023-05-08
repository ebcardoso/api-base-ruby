require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  context 'Success Path' do
    before(:all) do
      password = Faker::Internet.password(min_length: 8)
      params = {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password
      }
      post api_v1_auth_signup_path, params: params, as: :json
    end

    it 'should save a valid user on database' do
      @user = User.last
      expect(@user).to be_truthy
      expect(@user).to be_valid
    end

    it 'should return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'should contain :message and :access token' do
      expect(json_response).to have_key(:message)
      expect(json_response.dig(:message)).to eq(I18n.t('user.registration.success'))
      expect(json_response).to have_key(:content)
    end
  end

  context 'Failure - Missing Params' do
    before(:all) do
      post api_v1_auth_signup_path
    end

    it 'should return 400 if there is missing params' do
      expect(response).to have_http_status(400)
    end
  end

  context "Failure - Password confirmation invalid" do
    before(:all) do
      params = {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password(min_length: 8),
        password_confirmation: '123@456'
      }
      post api_v1_auth_signup_path, params: params, as: :json
    end

    it "should return 400 if password don't match" do
      expect(response).to have_http_status(400)
    end

    it "should return a message if passwords aren't the same" do
      expect(json_response).to have_key(:message)
      expect(json_response.dig(:message)).to eq(I18n.t('user.registration.errors.password_different'))
    end
  end
end
