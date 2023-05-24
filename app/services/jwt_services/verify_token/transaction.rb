module JwtServices
  module VerifyToken
    class Transaction < MainService
      step :validate_inputs
      step :decode_token
      step :check_expiration

      def validate_inputs(params)
        validation = Contract.call(params)

        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def decode_token(params)
        JwtServices::DecodeToken::Transaction.call(params) do |on|
          on.failure{ |result| Failure(result) }
          on.success{ |result| Success(result) }
        end
      end

      def check_expiration(payload)
        begin
          expiration = payload&.dig('expiration_date')&.to_datetime
          return Failure(I18n.t('token.verify.error')) if expiration.nil?

          if expiration > ActiveSupport::TimeZone[-3].now
            Success(I18n.t('token.decode.valid'))
          else
            Failure(I18n.t('token.decode.expired'))
          end
        rescue
          Failure(I18n.t('token.verify.error'))
        end
      end
    end
  end
end
