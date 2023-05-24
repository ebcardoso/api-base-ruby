module AuthServices
  module Signup
    class Transaction < MainService
      step :validate_inputs
      step :validate_password
      step :persist_user
      step :generate_token
      step :output

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

      def persist_user(params)
        user = User.new
        user.name = params[:name]
        user.email = params[:email]
        user.password = params[:password]
        
        if user.save
          Success(user)
        else
          Failure(I18n.t('user.registration.errors.persist_user'))
        end
      end

      def generate_token(input)
        params = {
          user_id: input.id.to_s,
          expiration_date: (ActiveSupport::TimeZone[-3].now+1.day).strftime('%Y-%m-%d %H:%M')
        }
        JwtServices::GenerateToken::Transaction.call(params) do |on|
          on.failure{ |result| Failure(I18n.t('token.generate.error')) }
          on.success{ |result| Success(result) }
        end
      end

      def output(input)
        response = {
          message: I18n.t('user.registration.success'),
          content: input
        }
        Success(response)
      end

    end
  end
end
