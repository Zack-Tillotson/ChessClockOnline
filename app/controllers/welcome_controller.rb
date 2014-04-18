class WelcomeController < ApplicationController

  def index
    @clock = Clock.new
  end

end
