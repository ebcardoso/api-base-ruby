module UsersServices
  module Index
    class Transaction < MainService
      step :get_items
      step :map_items

      def get_items
        items = User.all
        Success(items)
      rescue 
        Failure(I18n.t('user.index.errors'))
      end

      def map_items(items)
        response = items.map do |item|
        {
          id: item.id.to_s,
          name: item.name,
          email: item.email,
          registered_at: item.created_at.strftime('%d/%m/%Y %H:%M')
        }
        end
        Success(response)
      end

    end
  end
end
