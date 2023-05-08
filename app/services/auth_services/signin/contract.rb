module AuthServices
  module Signin
    class Contract < ApplicationContract
      schema do
        required(:email).value(:string)
        required(:password).value(:string)
      end
    end
  end
end
  