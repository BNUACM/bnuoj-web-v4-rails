class NewsController < ApplicationController

  # GET /news/{:id}
  def show
    news = News.find(params[:id]);
    if news.nil?
      render json: { msg: "News not found" }, status: :not_found
      return
    end
    render json: news.to_json(:methods => [:time_added_display])
  end

end
