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
      on.failure(:find_user) {|message| render json: {message:message, content: {}}, status: 401}
      on.failure(:validate_password) {|message| render json: {message:message, content: {}}, status: 401}
      on.failure(:generate_token) {|message| render json: {message:message, content: {}}, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def verify_token
    AuthServices::VerifyToken::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, is_valid: false, content: content}, status: 400}
      on.failure(:check_token) {|message| render json: {message: message, is_valid: false, content: {}}, status: 401}      
      on.success{|response| render json: {message: response, is_valid: true, content: {}}, status: 200}
    end
  end
end
