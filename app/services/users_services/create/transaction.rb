module UsersServices
  module Create
    class Transaction < MainService
      step :validate_inputs
      step :persist_user
      step :output

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)

        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def persist_user(params)
        user = User.new
        user.name = params[:name]
        user.email = params[:email]
        user.password = SecureRandom.hex(3)
        
        if user.save
          Success(user)
        else
          Failure(I18n.t('user.registration.errors.persist_user'))
        end
      end

      def output(user)
        response = {
          message: I18n.t('user.registration.success'),
          content: {
            name: user.name,
            email: user.email,
            registered_at: user.created_at.strftime('%d/%m/%Y %H:%M')
          }
        }
        Success(response)
      end

    end
  end
end
