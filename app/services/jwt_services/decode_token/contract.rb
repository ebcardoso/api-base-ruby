module JwtServices
  module DecodeToken
    class Contract < ApplicationContract
      schema do
        required(:token).value(:string)
      end
    end
  end
end
  