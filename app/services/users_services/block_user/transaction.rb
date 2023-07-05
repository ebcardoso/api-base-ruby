module UsersServices
  module BlockUser
    class Transaction < MainService
      step :block_user

      def block_user(model)
        model.is_blocked = true
        if model.save
          Success(I18n.t('user.block.success'))
        else
          Failure(I18n.t('user.block.errors'))
        end
      end
    end
  end
end
