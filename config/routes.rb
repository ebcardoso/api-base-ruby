Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :signup
        post :signin
        post :verify_token
      end

      namespace :profile do
        get :me
      end
    end
  end
end
