module UsersServices
  module Show
    class Transaction < MainService
      step :validate_inputs
      step :find_model
      step :output

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)
        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def find_model(params)
        model = User.where(
          id: params.dig(:id)
        ).first
        if model.present?
          Success(model)
        else
          Failure(I18n.t('user.errors.not_found'))
        end
      end

      def output(model)
        response = {
          id: model.id.to_s,
          name: model.name,
          email: model.email,
          registered_at: model.created_at.strftime('%d/%m/%Y %H:%M')
        }
        Success(response)
      end

    end
  end
end
