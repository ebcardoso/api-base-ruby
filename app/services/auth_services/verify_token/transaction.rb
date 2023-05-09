module AuthServices
  module VerifyToken
    class Transaction < MainService
      step :validate_inputs
      step :check_token

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)

        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def check_token(input)
        params = { token: input.dig('token') }
        JwtServices::VerifyToken::Transaction.call(params) do |on| 
          on.failure{|result| Failure(result)}
          on.success{|result| Success(result)}
        end
      end

    end
  end
end