class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by_email(login_params[:email])
    if @user&.authenticate(login_params[:password])
      token = JsonWebToken.encode({user_id: @user.id}, algorithm)
      time = Time.now + 24.hours.to_i
      render json: { token: token, expire: time.strftime("%m-%d-%Y %H:%M"),
                      username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def algorithm
    { algorithm: 'HS512' }
  end

  def login_params
    params.permit(:email, :password)
  end
end
