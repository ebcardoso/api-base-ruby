module UsersServices
  module Create
    class Transaction < MainService
      step :validate_inputs
      step :persist_model
      step :output

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)

        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def persist_model(params)
        model = User.new
        model.name = params[:name]
        model.email = params[:email]
        model.password = SecureRandom.hex(3)
        
        if model.save
          Success(model)
        else
          Failure(I18n.t('user.create.errors'))
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
