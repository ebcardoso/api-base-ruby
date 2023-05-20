class Api::V1::ProfileController < ApiController
  def my_user
    render json: {
      name: @current_user.name,
      email: @current_user.email,
      registered_in: (@current_user.created_at-3.hours).strftime('%Y-%m-%d %H:%M')
    }
  end

end
