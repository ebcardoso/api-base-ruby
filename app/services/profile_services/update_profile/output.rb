module ProfileServices
  module UpdateProfile
    class Output < MainService
      def call(current_user)
        {
          id: current_user.id.to_s,
          name: current_user.name,
          email: current_user.email
        }
      end

    end
  end
end
