module AuthServices
  module ForgotPasswordToken
    class Contract < ApplicationContract
      schema do
        required(:email).value(:string)
      end
    end
  end
end
