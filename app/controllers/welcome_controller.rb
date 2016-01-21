class WelcomeController < ApplicationController

  def index
  	@skip_container = true
  end

  def shifty
  end

  def contact
  	ContactMailer.contact_email(params[:name], params[:email], params[:phone], params[:message]).deliver
  	flash[:success] = "Email sent!"
  	redirect_to root_path
  end
end
