class ApplicationsController < ApplicationController
  before_filter :login_required

  def new
    @application = Application.new
  end

  def index
    @applications = current_user.applications
  end

  def create
    @application = Application.new(params[:application])
    @application.user = current_user
    @application.environment = {'foo' => '123'}.to_json

    if @application.save
      redirect_to applications_url
    else
      render :new
    end
  end

  def destroy
    @application = Application.find(params[:id])
    if @application.user == current_user
      @application.destroy
      redirect_to applications_url
    else
      render :status => :forbidden, :text => "Forbidden"
    end
  end
end