module ProfileServices
  module UpdateProfile
    class Transaction < MainService
      step :validate_inputs
      step :change_fields
      step :presenter

      def validate_inputs(params)
        validation = Contract.call(params[:params].permit!.to_h)
        if validation.success?
          Success[params.dig(:params), params.dig(:current_user)]
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def change_fields(input)
        params = input[0]
        current_user = input[1]

        current_user.name = params&.dig(:name)
        if current_user.save
          Success(current_user)
        else
          Failure(I18n.t('user.update_profile.error'))
        end
      end

      def presenter(current_user)
        output = Output.call(current_user)
        Success(output)
      end

    end
  end
end
