module AuthServices
  module ResetPasswordConfirm
    class Transaction < MainService
      step :validate_inputs
      step :validate_password
      step :find_user_by_token
      step :validate_token_deadline
      step :update_password

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)
        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def validate_password(params)
        if params[:password]==params[:password_confirmation]
          Success(params) 
        else
          Failure(I18n.t('user.registration.errors.password_different'))
        end
      end

      def find_user_by_token(params)
        user = User.where(
          token_password_recovery: params.dig(:token)
        ).first
        if user.present?
          Success[params, user]
        else
          Failure(I18n.t('user.errors.not_found'))
        end
      end

      def validate_token_deadline(input)
        params = input[0]
        user = input[1]

        if ActiveSupport::TimeZone[-3].now > user.token_password_recovery_deadline
          Failure(I18n.t('user.reset_password.errors.deadline'))
        else
          Success(input)
        end
      end

      def update_password(input)
        params = input[0]
        user = input[1]

        user.password = params[:password]

        if user.save
          Success(I18n.t('user.reset_password.success'))
        else
          Failure(I18n.t('user.reset_password.errors.change'))
        end
      end
      
    end
  end
end
