require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") unless Rails.env.test?
# Object.send(:remove_const, :ActiveRecord)
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each do |f|
  require f
end

RSpec.configure do |config|
  config.use_active_record = false
  config.include(FactoryBot::Syntax::Methods)
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Request::JsonHelpers, type: :request
end
