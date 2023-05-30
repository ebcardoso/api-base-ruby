module UsersServices
  module SetModel
    class Transaction < MainService
      step :validate_inputs
      step :find_model

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

    end
  end
end
