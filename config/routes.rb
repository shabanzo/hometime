# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :reservations do
      collection do
        post :upsert
      end
    end
  end
end
