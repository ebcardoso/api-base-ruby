class Api::V1::UsersController < ApiController
  def show
    UsersServices::Show::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:find_user) {|message| render json: {message: message}, status: 404}
      on.failure {|response| render json: response, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def create
    UsersServices::Create::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:persist_user) {|message| render json: {message: message, content: {}}, status: 500}
      on.failure {|response| render json: response, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def update
    UsersServices::Update::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:find_user) {|message| render json: {message: message}, status: 404}
      on.failure {|response| render json: response, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def destroy
    UsersServices::Destroy::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:find_user) {|message| render json: {message: message}, status: 404}
      on.failure {|response| render json: {message: response}, status: 500}
      on.success {|response| render json: {message: response}, status: 200}
    end
  end
end
