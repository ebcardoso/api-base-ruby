module UsersServices
  module Create
    class Contract < ApplicationContract
      schema do
        required(:name).value(:string)
        required(:email).value(:string)
      end
      
      rule(:name) do
        key.failure('Name must to have at least 6 characters') if value.length < 6
      end
    end
  end
end
