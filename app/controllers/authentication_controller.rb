class AuthenticationController < ApplicationController

  def authenticate
    auth_token =  AuthenticateUser.new(auth_params[:email],auth_params[:passwrod]).call
    json_response(auth_toke:auth_token)
  end

  private

  def auth_params
    params.permit(:email,:password)
  end
end
