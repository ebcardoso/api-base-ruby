module UsersServices
  module Destroy
    class Transaction < MainService
      step :validate_inputs
      step :find_user
      step :destroy_user

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)
        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def find_user(params)
        user = User.where(
          id: params.dig(:id)
        ).first
        if user.present?
          Success(user)
        else
          Failure(I18n.t('user.errors.not_found'))
        end
      end

      def destroy_user(user)
        if user.destroy
          Success(I18n.t('user.destroy.success'))
        else
          Failure(I18n.t('user.destroy.errors'))
        end
      end

    end
  end
end
