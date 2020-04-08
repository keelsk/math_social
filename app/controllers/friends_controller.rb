class FriendsController < ApplicationController
  get "/friends/:id" do
    @user = User.find_by(params[:id])
    @friends = @user.get_friends
    erb :"friends/index"
  end

  get "/friends/:username/add" do
    friend = Friend.find_or_create_by(username: params[:username])
    current_user.friends << friend
    redirect "/friends/#{current_user.username}"
  end

  delete "/friends/:friend_username" do
    friend = Friend.find_by(username: params[:friend_username])
    friend.destroy
    username = current_user.username
    redirect "/friends/#{username}"
  end
end
