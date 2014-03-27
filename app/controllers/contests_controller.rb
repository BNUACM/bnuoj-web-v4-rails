class ContestsController < ApplicationController

  def index
    @page_title = "Contest List"
    respond_to do |format|
      format.html
      format.json {
        render json: ContestsDatatable.new(view_context)
      }
    end
  end

  def show
  end

end
