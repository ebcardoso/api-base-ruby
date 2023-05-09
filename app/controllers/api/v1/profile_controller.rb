class Api::V1::ProfileController < ApiController
  def me
    render json: {status: "authenticated : #{@current_user.name}"}
  end

end
