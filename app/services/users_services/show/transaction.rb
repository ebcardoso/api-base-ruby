module UsersServices
  module Show
    class Transaction < MainService
      step :output

      def output(model)
        response = {
          id: model.id.to_s,
          name: model.name,
          email: model.email,
          is_blocked: model.is_blocked,
          registered_at: model.created_at.strftime('%d/%m/%Y %H:%M')
        }
        Success(response)
      end

    end
  end
end
