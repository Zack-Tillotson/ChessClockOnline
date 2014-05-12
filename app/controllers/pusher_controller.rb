class PusherController < ApplicationController

  require 'pusher'

  protect_from_forgery :except => :authenticate # stop rails CSRF protection for this action

  def authenticate

    begin
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      render :json => response
    rescue Exception => e
      render :json => {error: e.to_s}
    end
    
  end

end
