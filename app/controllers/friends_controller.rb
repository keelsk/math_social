class FriendsController < ApplicationController
  get "/friends/:user" do
    erb :"friends/index"
  end
end
