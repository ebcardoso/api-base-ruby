module ProfileServices
  module UpdatePassword
    class Contract < ApplicationContract
      schema do
        required(:current_password).value(:string)
        required(:password).value(:string)
        required(:password_confirmation).value(:string)
      end
      
      rule(:password) do
        key.failure('Password must to have at least 6 characters') if value.length < 6
      end
    end
  end
end
  