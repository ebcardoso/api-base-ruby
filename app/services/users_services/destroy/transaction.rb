module UsersServices
  module Destroy
    class Transaction < MainService
      step :destroy_model

      def destroy_model(model)
        if model.destroy
          Success(I18n.t('user.destroy.success'))
        else
          Failure(I18n.t('user.destroy.errors'))
        end
      end

    end
  end
end
