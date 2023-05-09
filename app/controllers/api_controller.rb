class ApiController < ApplicationController
  before_action :authenticate_request
end
