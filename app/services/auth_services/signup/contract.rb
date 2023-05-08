module AuthServices
  module Signup
    class Contract < ApplicationContract
      schema do
        required(:name).value(:string)
        required(:email).value(:string)
        required(:password).value(:string)
        required(:password_confirmation).value(:string)
      end
    end
  end
end
