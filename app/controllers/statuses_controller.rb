class StatusesController < ApplicationController

  def index
    @page_title = "Status List"
    respond_to do |format|
      format.html
      format.json {
        render json: StatusesDatatable.new(view_context)
      }
    end
  end

  def show
    @status = Status.find(params[:id])
    viewable = begin
      if !logged_in?
        false
      else
        if @status.isshared || current_user.username.casecmp(@status.username) == 0 || current_user.is_admin?
          true
        else
          false
        end
      end
    end
    if viewable
      @page_title = "Source Code of Run #{@status.runid}"
      respond_to do |format|
        format.html
        format.json {
          options = {}
          options[:except] = []
          if !logged_in? || !current_user.is_admin?
            options[:except] |= [:ipaddr]
          end
          render json: @status.to_json(options)
        }
      end
    else
      p request.path
      redirect_to url_for(:controller => 'users', :action => 'signin', :params => {:redirect_to => request.path })
    end
  end

end
