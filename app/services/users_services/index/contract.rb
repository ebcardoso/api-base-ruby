module UsersServices
  module Index
    class Contract < ApplicationContract
      schema do
        optional(:page).value(:string)
        optional(:search).value(:string)
      end
    end
  end
end
