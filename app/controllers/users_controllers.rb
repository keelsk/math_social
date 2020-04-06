class UsersController < ApplicationController
  get '/login' do
    erb :'users/login'
  end

  post '/login' do
  end

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == ""
      redirect '/signup'
      flash[:message] = "Please enter a valid username and password"
    end
    @user = User.create(params, img_url: generate_image)
    if @user.save
      session[:user_id] = @user.id
      redirect '/problems'
    else
      redirect '/signup'
  end
end
