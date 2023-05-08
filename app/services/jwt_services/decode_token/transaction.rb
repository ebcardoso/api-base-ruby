module JwtServices
  module DecodeToken
    class Transaction < MainService
      step :validate_inputs
      step :decode_token

      def validate_inputs(params)
        validation = Contract.call(params)

        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def decode_token(params)
        begin
          decoded_token = JWT.decode params.dig(:token), nil, false
          Success(decoded_token[0])
        rescue
          Failure(I18n.t('token.decode.error'))
        end
      end

    end
  end
end
