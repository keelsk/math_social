class FriendsController < ApplicationController
  get "/friends/:id" do
    redirect "/login" if !logged_in?
    @friends = current_user.get_friends
    @friend_rows = @friends.each_slice(4).to_a if !@friends.empty?
    @other_users = User.all.select {|user| !current_user.friends.include?(user.username) && user.id != current_user.id}
    @other_users_rows = @other_users.each_slice(4) if !@other_users.empty?
    erb :"friends/index"
  end

  get "/friends/:username/add" do
    redirect "/login" if !logged_in?
    friend = Friend.find_or_create_by(username: params[:username])
    current_user.friends << friend
    redirect "/friends/#{current_user.id}"
  end

  delete "/friends/:friend_username" do
    friend = Friend.find_by(username: params[:friend_username])
    current_user.friends.delete(friend)
    id = current_user.id
    redirect "/friends/#{id}"
  end
end
