class Api::V1::UsersController < ApiController
  before_action :set_model, only: %i[show update destroy block_user]

  def index
    UsersServices::Index::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure {|response| render json: {message: response}, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def show
    UsersServices::Show::Transaction.call(@model) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:find_model) {|message| render json: {message: message}, status: 404}
      on.failure {|response| render json: response, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def create
    UsersServices::Create::Transaction.call(params) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:persist_model) {|message| render json: {message: message, content: {}}, status: 500}
      on.failure {|response| render json: response, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def update
    UsersServices::Update::Transaction.call({params: params, model:@model}) do |on|
      on.failure(:validate_inputs) {|message, content| render json: {message: message, content: content}, status: 400}
      on.failure(:find_model) {|message| render json: {message: message}, status: 404}
      on.failure {|response| render json: response, status: 500}
      on.success {|response| render json: response, status: 200}
    end
  end

  def destroy
    UsersServices::Destroy::Transaction.call(@model) do |on|
      on.failure {|response| render json: {message: response}, status: 500}
      on.success {|response| render json: {message: response}, status: 200}
    end
  end

  def block_user
    UsersServices::BlockUser::Transaction.call(@model) do |on|
      on.failure { |response| render json: { message: response }, status: 500 }
      on.success { |response| render json: { message: response }, status: 200 }
    end
  end

  private

    def set_model
      @model = UsersServices::SetModel::Transaction.call(params) do |on|
        on.failure(:validate_inputs) {|message, content| return render json: {message: message, content: content}, status: 400}
        on.failure(:find_model) {|message| return render json: {message: message}, status: 404}
        on.failure {|response| return render json: response, status: 500}
        on.success {|response| response}
      end
    end
end
