module ProfileServices
  module UpdatePassword
    class Transaction < MainService
      step :validate_inputs
      step :validate_password
      step :validate_new_password
      step :change_password

      def validate_inputs(params)
        validation = Contract.call(params[:params].permit!.to_h)
        if validation.success?
          Success[params.dig(:params), params.dig(:current_user)]
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def validate_password(input)
        params = input[0]
        user = input[1]
        if user.authenticate(params.dig(:current_password))
          Success(input)
        else
          Failure('Current password is wrong')
        end
      end

      def validate_new_password(input)
        params = input[0]
        if params[:password]==params[:password_confirmation]
          Success(input) 
        else
          Failure(I18n.t('user.registration.errors.password_different'))
        end
      end

      def change_password(input)
        params = input[0]
        user = input[1]
        user.password = params[:password]
        if user.save
          Success(I18n.t('user.update_password.success'))
        else
          Failure(I18n.t('user.update_password.error'))
        end
      end

    end
  end
end
