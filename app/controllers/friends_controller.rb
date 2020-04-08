class FriendsController < ApplicationController
  get "/friends/:username" do
    @user = User.find_by(username: params[:username])
    @friends = @user.get_friends
    erb :"friends/index"
  end

  delete "/friends/:friend_username" do
    friend = Friend.find_by(username: params[:friend_username])
    friend.destroy
    username = current_user.username
    redirect "/friends/#{username}"
  end
end
 
