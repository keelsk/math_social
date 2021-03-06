require 'pry'
class UsersController < ApplicationController
  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/problem-home'
    else
      flash[:message] = "Please enter a valid username and password."
      redirect '/login'
    end
  end

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == "" || User.all.any?{|user| user.username.downcase == params[:username].downcase}
      if User.all.any?{|user| user.username.downcase == params[:username].downcase}
        flash[:message] = "Please choose another username. The username you entered is already in use."
      else
        flash[:message] = "Please enter a valid username and password."
      end
      redirect '/signup'
    end
    params[:img_url] = generate_image
    user = User.create(params)
    if user.save
      session[:user_id] = user.id
      redirect '/problem-home'
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
