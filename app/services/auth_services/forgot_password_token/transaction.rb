module AuthServices
  module ForgotPasswordToken
    class Transaction < MainService
      step :validate_inputs
      step :find_user
      step :generate_token
      step :send_email

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
          email: params.dig(:email)
        ).first
        if user.present?
          Success(user)
        else
          Failure(I18n.t('user.errors.not_found'))
        end
      end

      def generate_token(user)
        user.token_password_recovery = SecureRandom.hex(3)
        user.token_password_recovery_deadline = ActiveSupport::TimeZone[-3].now+10.minutes
      
        if user.save
          Success(user)
        else
          Failure(I18n.t('user.forgot_password.errors.generate_token'))
        end
      end

      def send_email(user)
        Thread.new do
          ApplicationMailer.token_forgot_password(
            user.email, 
            user.token_password_recovery).deliver
        end
        Success(I18n.t('user.forgot_password.success'))
      end
      
    end
  end
end
