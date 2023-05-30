module UsersServices
  module Update
    class Transaction < MainService
      step :validate_inputs
      step :update_model

      def validate_inputs(params)
        @params = params[:params]
        @model = params[:model]

        validation = Contract.call(@params.permit!.to_h)
        if validation.success?
          Success[@params, @model]
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def update_model(input)
        params = input[0]
        model = input[1]

        model.name = params.dig(:name) if params.dig(:name)
        model.email = params.dig(:email) if params.dig(:email)

        if model.save
          response = {
            id: model.id.to_s,
            name: model.name,
            email: model.email,
            registered_at: model.created_at.strftime('%d/%m/%Y %H:%M')
          }
          Success(response)
        else
          Failure(I18n.t('user.update.errors'))
        end
      end
    end
  end
end
