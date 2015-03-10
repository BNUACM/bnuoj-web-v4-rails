class HomeController < ApplicationController
  def index
  end

  def server_time
    render plain: Time.now.to_s
  end
end
