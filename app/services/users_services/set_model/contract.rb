module UsersServices
  module SetModel
    class Contract < ApplicationContract
      schema do
        required(:id).value(:string)
      end
    end
  end
end
