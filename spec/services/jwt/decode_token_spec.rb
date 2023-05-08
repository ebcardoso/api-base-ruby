require 'rails_helper'

RSpec.describe JwtServices::DecodeToken::Transaction do
  context 'Success Path - token decoded successfully' do
    before(:all) do
      @payload = {
        user_id: SecureRandom.hex(10),
        expiration_date: (DateTime.now+1.day).strftime('%Y-%m-%d %H:%M')
      }
      token = JWT.encode @payload, nil, 'none'
      @decoded_token = JwtServices::DecodeToken::Transaction.call({token: token}) do |on|
        on.failure{ |result| {} }
        on.success{ |result| result }
      end
    end

    it 'should return the fields' do
      expect(@decoded_token).to have_key('user_id')
      expect(@decoded_token).to have_key('expiration_date')
    end

    it 'should contain the correct informations' do
      expect(@decoded_token.dig('user_id')).to eq(@payload.dig(:user_id))
      expect(@decoded_token.dig('expiration_date')).to eq(@payload.dig(:expiration_date))
    end
  end

  context 'Failure - Missing Params' do
    it 'should return an failure' do
      @result = JwtServices::DecodeToken::Transaction.call({})
      expect(@result.failure?).to be_truthy
    end
  end
end
