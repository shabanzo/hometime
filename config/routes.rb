# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :reservations do
        collection do
          post :upsert
        end
      end
    end
  end
end
