module AuthServices
  module VerifyToken
    class Contract < ApplicationContract
      schema do
        required(:token).value(:string)
      end
    end
  end
end
