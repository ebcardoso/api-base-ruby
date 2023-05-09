require 'rails_helper'

RSpec.describe JwtServices::VerifyToken::Transaction do  
  context 'Success Path - Token is still valid' do
    before(:all) do
      @payload = {
        user_id: SecureRandom.hex(10),
        expiration_date: (DateTime.now+1.day).strftime('%Y-%m-%d %H:%M')
      }
      token = JWT.encode @payload, nil, 'none'
      @result = JwtServices::VerifyToken::Transaction.call({token: token})
    end

    it 'should return success' do
      expect(@result.success?).to be_truthy
      expect(@result.success).to eq(I18n.t('token.decode.valid'))
    end
  end

  context 'Failure - Missing Params' do
    before(:all) do
      @result = JwtServices::VerifyToken::Transaction.call({})
    end

    it 'should return a failure message' do
      expect(@result.failure?).to be_truthy
      expect(@result.failure[0]).to eq(I18n.t('params.invalid'))
    end
  end

  context 'Failure - Sending an random invalid Token' do
    before(:all) do
      token = 'ascapsikchakscljbaclajbclkacbalksj'
      @result = JwtServices::VerifyToken::Transaction.call({token: token})
    end

    it 'should return a message' do
      expect(@result.failure).to be_truthy
    end
  end

  context 'Failure - Expired Token' do
    before(:all) do
      @payload = {
        user_id: SecureRandom.hex(10),
        expiration_date: (DateTime.now).strftime('%Y-%m-%d %H:%M')
      }
      token = JWT.encode @payload, nil, 'none'
      @result = JwtServices::VerifyToken::Transaction.call({token: token})
    end

    it 'should return a message' do
      expect(@result.failure).to be_truthy
    end
  end
end
