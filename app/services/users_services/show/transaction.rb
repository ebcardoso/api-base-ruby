module UsersServices
  module Show
    class Transaction < MainService
      step :validate_inputs
      step :find_user
      step :output

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

      def output(user)
        response = {
          id: user.id.to_s,
          name: user.name,
          email: user.email,
          registered_at: user.created_at.strftime('%d/%m/%Y %H:%M')
        }
        Success(response)
      end

    end
  end
end
