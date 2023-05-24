class Api::V1::ProfileController < ApiController
  def my_user
    render json: {
      name: @current_user.name,
      email: @current_user.email,
      registered_in: (@current_user.created_at-3.hours).strftime('%Y-%m-%d %H:%M')
    }
  end

  def update_profile
    ProfileServices::UpdateProfile::Transaction.call({params: params, current_user: @current_user}) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure{|message| render json: {message: message, content: {}}, status: 500}
      on.success{|response| render json: response, status: 200}
    end
  end

  def update_password
    ProfileServices::UpdatePassword::Transaction.call({params: params, current_user: @current_user}) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:validate_password) {|message| render json: {message: message, content: {}}, status: 403}
      on.failure(:validate_new_password) {|message| render json: {message: message, content: {}}, status: 400}
      on.failure{|message| render json: {message: message, content: {}}, status: 500}
      on.success{|response| render json: {message: response, content: {}}, status: 200}
    end
  end
end
