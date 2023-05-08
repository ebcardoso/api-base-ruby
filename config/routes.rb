Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :signup
      end
    end
  end
end
