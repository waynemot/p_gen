Rails.application.routes.draw do
  resource :passwords
  post "/", controller: :passwords, action: :new
  patch "/", controller: :passwords, action: :new
  post "/passwords/new", controller: :passwords, action: :new
  patch "/passwords/new", controller: :passwords, action: :new
  patch "/passwords/show", controller: :passwords, action: :new
  get "/passwords", controller: :passwords, action: :new
  get "/passwords/", controller: :passwords, action: :new

  get '/pw_tests', controller: :pw_tests, action: :index
  root controller: :passwords, action: :index
end
