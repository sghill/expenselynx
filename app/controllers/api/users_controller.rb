class Api::UsersController < ApplicationController

  respond_to :json, :xml

  expose(:user) do
    current_user
  end

  def current
    respond_with user
  end
end
