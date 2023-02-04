Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/sign-in", to: "khateebs#sign_in"
  post "/sign-up", to: "khateebs#sign_up"
  get "/khateebs/:username", to: "khateebs#show"
  put "/khateebs/:username/avatar", to: "khateebs#change_avatar"

  get "/reminders", to: "reminders#show_feed"
  reminder "/reminders", to: "reminders#create"
  reminder "/reminders/:reminder_id", to: "reminders#like"
  delete "/reminders/:reminder_id", to: "reminders#unlike"

  post "/follow", to: "follows#create"
  delete "/follow", to: "follows#destroy"

end