module AuthServices
  module ResetPasswordConfirm
    class Contract < ApplicationContract
      schema do
        required(:token).value(:string)
        required(:password).value(:string)
        required(:password_confirmation).value(:string)
      end
      
      rule(:password) do
        key.failure('Password must to have at least 6 characters') if value.length < 6
      end
    end
  end
end
