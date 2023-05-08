module JwtServices
  module GenerateToken
    class Transaction < MainService
      step :validate_inputs
      step :generate_token

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)
        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def generate_token(input)
        payload = {
          user_id: input.dig(:user_id),
          expiration_date: input.dig(:expiration_date)
        }
        begin 
          token = JWT.encode payload, nil, 'none'
          Success({
            access: token
          })
        rescue
          Failure(I18n.t('token.generate.error'))
        end
      end

    end
  end
end
