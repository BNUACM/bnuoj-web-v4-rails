require 'socket'

class StatusesController < ApplicationController

  before_action :need_login, :check_submit_valid, only: [:create]
  before_action :check_visibility, only: [:show, :compile_info, :update]

  def index
    @page_title = t("status.titles.list")
    respond_to do |format|
      format.html
      format.json {
        render json: StatusesDatatable.new(view_context)
      }
    end
  end

  # Check if the current run is visible to current user.
  def check_visibility
    set_status
    viewable = begin
      if !logged_in?
        false
      else
        if @status.isshared ||
            current_user.username.casecmp(@status.username) == 0 ||
            current_user.is_admin?
          true
        else
          false
        end
      end
    end

    unless viewable
      respond_to do |format|
        format.html {
          redirect_to(
              url_for(
                  :controller => 'users',
                  :action => 'signin',
                  :params => {:redirect_to => request.path }),
              status: :temporary_redirect)
        }
        format.json {
          render status: :forbidden, nothing: true
        }
      end
      return
    end
  end

  # Show compile info, standalone page.
  def compile_info
    @page_title = t("status.titles.compile_info", runid: @status.runid)
    respond_to do |format|
      format.html
      format.json {
        options = {}
        options[:only] = [:ce_info, :runid]
        render json: @status.to_json(options)
      }
    end
  end

  # Show source code, standalone page.
  def show
    @page_title = t("status.titles.show", runid: @status.runid)
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
  end

  # POST /statuses
  # POST /statuses.json
  def create
    create_params = status_params
    create_params[:username] = current_user.username
    create_params[:time_submit] = Time.now
    create_params[:result] = t("status.results.waiting")
    create_params[:ipaddr] = request.remote_ip
    create_params[:jnum] = 0
    create_params[:contest_belong] = 0 if @contest && @contest.ended?

    @status = Status.new(create_params)
    if @status.save
      begin
        send_socket_message(
            runid: @status.runid,
            vname: @problem.vname,
            type: OJ_CONFIG["contact"]["string"]["submit"])
        @problem.total_submit = @problem.total_submit + 1
        @problem.save
        current_user.total_submit = current_user.total_submit + 1
        current_user.save
      rescue
      end
      render json: { msg: t("status.prompts.submitted") }, status: :created
    else
      render json: { msg: @status.errors }, status: :unprocessable_entity
    end
  end

  # Notify dispacther.
  def send_socket_message options={}
    sock = TCPSocket.new(
        OJ_CONFIG["contact"]["server"],
        OJ_CONFIG["contact"]["port"])
    sock.puts options[:type]
    sock.puts options[:runid]
    sock.puts options[:vname]
    sock.close
  end

  # Check whether the submit is valid.
  def check_submit_valid
    begin
      if params[:status][:source].length > 
          JS_CONFIG["limits"]["max_source_code_len"]
        raise t("status.prompts.source_code_too_long") 
      end
      begin
        @problem = Problem.find(params[:status][:pid])
      rescue
        raise t("problem.prompts.nonexist")
      end
      if params[:status][:contest_belong].to_i == 0 &&
          @problem.hide && !current_user.is_admin?
        raise t("problem.prompts.nonexist")
      else
        begin
          @contest = Contest.find(params[:status][:contest_belong].to_i)
        rescue
          raise t("contest.prompts.nonexist")
        end
        unless @contest.has_user(current_user.username)
          raise t("global.prompts.access_denied");
        end
        if ContestProblem.where(
            cid: params[:status][:contest_belong].to_i,
            pid: params[:status][:pid].to_i).empty?
          raise t("problem.prompts.nonexist")
        end
      end
      raise t("status.prompts.language_unspecified") if 
        params[:status][:language].to_i == 0
      last_status = Status.where(username: current_user.username)
          .order(time_submit: :desc).first
      raise t("global.prompts.too_frequent") if
        Time.now - last_status.time_submit < 5
    rescue Exception => e
      render status: :not_acceptable, json: { msg: e.message }
      return
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  # only allow updating 'isshared'
  def update
    respond_to do |format|
      if @status.update(isshared: params[:isshared])
        format.json { head :no_content }
      else
        format.json {
          render json: @status.errors,
          status: :unprocessable_entity
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status ||= Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def status_params
      params.require(:status).permit(
          [:pid, :source, :language, :isshared, :contest_belong])
    end

end
