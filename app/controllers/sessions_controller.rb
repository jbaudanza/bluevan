class SessionsController < ApplicationController
  def new
    @auth_url = User::GITHUB_CLIENT.auth_code.authorize_url(
        :redirect_uri => callback_session_url,
        :state => form_authenticity_token,
        :scope => 'user')
  end

  def callback
    if params[:state] != form_authenticity_token
      render :status => :forbidden, :text => 'CSRF failure.'
      return
    end

    token = User::GITHUB_CLIENT.auth_code.get_token(
        params[:code],
        :redirect_uri => callback_session_url)

    user = User.find_or_create_by_oauth2(token)

    if user
      reset_session
      session[:user_id] = user.id

      user.update_keys!

      redirect_to applications_url
    else
      render :status => :forbidden, :text => 'Forbidden'
    end
  end

  def destroy
    reset_session
    redirect_to new_session_url
  end

end