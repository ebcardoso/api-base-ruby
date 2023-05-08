class Api::V1::AuthController < ApplicationController
  def signup
    AuthServices::Signup::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:validate_password) {|message| render json: {message: message, content: {}}, status: 400}
      on.failure(:persist_user) {|message| render json: {message: message, content: {}}, status: 500}
      on.failure(:generate_token) {|message| render json: {message: message, content: {}}, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def signin
    AuthServices::Signin::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:find_user) {|message| render json: {message:message}, status: 401}
      on.failure(:validate_password) {|message| render json: {message:message}, status: 401}
      on.failure(:generate_token) {|message| render json: {message:message}, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end
end
