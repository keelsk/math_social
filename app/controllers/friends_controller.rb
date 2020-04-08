class FriendsController < ApplicationController
  get "/friends/:id" do
    @friends = current_user.get_friends
    erb :"friends/index"
  end

  get "/friends/:username/add" do
    friend = Friend.find_or_create_by(username: params[:username])
    current_user.friends << friend
    redirect "/friends/#{current_user.id}"
  end

  delete "/friends/:friend_username" do
    friend = Friend.find_by(username: params[:friend_username])
    current_user.friends.delete(friend)
    # friend.destroy
    id = current_user.id
    redirect "/friends/#{id}"
  end
end
