module AuthServices
  module Signin
    class Transaction < MainService
      step :validate_inputs
      step :find_user
      step :validate_password
      step :generate_token

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
          Success[params, user]
        else
          Failure('Invalid Credentials')
        end
      end

      def validate_password(input)
        params = input[0]
        user = input[1]
        if user.authenticate(params.dig(:password))
          Success(user)
        else
          Failure('Invalid Credentials')
        end
      end

      def generate_token(user)
        params = {
          user_id: user.id.to_s,
          expiration_date: (ActiveSupport::TimeZone[-3].now+1.day).strftime('%Y-%m-%d %H:%M')
        }          
        JwtServices::GenerateToken::Transaction.call(params) do |on|
          on.failure{ |result| Failure(result) }
          on.success{ |result| 
            Success({
              message: I18n.t('user.signin.success'),
              content: result
            }) 
          }
        end
      end
    end
  end
end
