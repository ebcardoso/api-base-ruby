class ApplicationController < ActionController::API

  private
    def authenticate_request
      #Checking Token Presence
      if request.headers[:authorization].nil?
        return render json: {message: 'Missing Token', content:{}}, status: 401
      end

      #Decoding Token
      token = request.headers[:authorization]&.split(' ')&.last
      @content = JwtServices::DecodeToken::Transaction.call({token: token}) do |on|
        on.failure{|failure| return render json: {message: 'Invalid Token!', content:{}}, status: 401 }
        on.success{|result| result}
      end
      
      #Verify if the user User exists
      @current_user = User.where(id: @content&.dig('user_id')).first
      if @current_user.nil?
        return render json: {message: 'Access not allowed!', content:{}}, status: 401
      end
    end
end
