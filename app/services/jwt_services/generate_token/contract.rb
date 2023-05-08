module JwtServices
  module GenerateToken
    class Contract < ApplicationContract
      schema do
        required(:user_id).value(:string)
        required(:expiration_date).value(:string)
      end
    end
  end
end
