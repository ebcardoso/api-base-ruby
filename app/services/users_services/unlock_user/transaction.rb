module UsersServices
  module UnlockUser
    class Transaction < MainService
      step :unlock_user

      def unlock_user(model)
        model.is_blocked = false
        if model.destroy
          Success(I18n.t('user.unlock.success'))
        else
          Failure(I18n.t('user.unlock.errors'))
        end
      end
    end
  end
end
