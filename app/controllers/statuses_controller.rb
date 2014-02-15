class StatusesController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json {
        render json: StatusesDatatable.new(view_context)
      }
    end
  end

end
