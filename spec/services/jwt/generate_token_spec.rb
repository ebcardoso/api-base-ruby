require 'rails_helper'

RSpec.describe JwtServices::GenerateToken::Transaction do
  describe 'Success Path - Token Generated' do
    before(:all) do
      @params = {
        user_id: SecureRandom.hex(10),
        expiration_date: (DateTime.now+1.day).strftime('%Y-%m-%d %H:%M')
      }
      @result = JwtServices::GenerateToken::Transaction.call(@params) do |on|
        on.failure{ |result| {} }
        on.success{ |result| result }
      end
    end

    it 'should return a access token' do
      expect(@result).to have_key(:access)
    end

    it 'should be a valid token' do
      payload = {
        user_id: @params[:user_id],
        expiration_date: @params[:expiration_date]
      }
      token = JWT.encode payload, nil, 'none'
      expect(@result[:access]).to eq(token)
    end
  end
  
  describe 'Failure - Missing Params' do
    it 'should return an failure' do
      @result = JwtServices::GenerateToken::Transaction.call({})
      expect(@result.failure?).to be_truthy
    end
  end
end
