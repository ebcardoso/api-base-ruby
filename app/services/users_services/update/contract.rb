module UsersServices
  module Update
    class Contract < ApplicationContract
      schema do
        optional(:name).value(:string)
        optional(:email).value(:string)
      end
    end
  end
end
