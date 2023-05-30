module UsersServices
  module Index
    class Contract < ApplicationContract
      schema do
        optional(:page).value(:string)
      end
    end
  end
end
