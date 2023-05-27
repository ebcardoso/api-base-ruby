module UsersServices
  module Update
    class Transaction < MainService
      step :validate_inputs
      step :find_user
      step :update_user

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
          Success[params, user]
        else
          Failure(I18n.t('user.errors.not_found'))
        end
      end

      def update_user(input)
        params = input[0]
        user = input[1]

        user.name = params.dig(:name) if params.dig(:name)
        user.email = params.dig(:email) if params.dig(:email)

        if user.save
          response = {
            id: user.id.to_s,
            name: user.name,
            email: user.email,
            registered_at: user.created_at.strftime('%d/%m/%Y %H:%M')
          }
          Success(response)
        else
          Failure(I18n.t('user.update.errors'))
        end
      end
    end
  end
end
