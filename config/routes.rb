Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :signup
        post :signin
      end
    end
  end
end
