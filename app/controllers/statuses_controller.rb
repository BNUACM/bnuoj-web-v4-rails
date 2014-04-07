require 'socket'

class StatusesController < ApplicationController

  before_action :need_login, :check_submit_valid, only: [:create]
  before_action :check_visibility, only: [:show, :compile_info]

  def index
    @page_title = "Status List"
    respond_to do |format|
      format.html
      format.json {
        render json: StatusesDatatable.new(view_context)
      }
    end
  end

  def check_visibility
    set_status
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

    unless viewable
      respond_to do |format|
        format.html {
          redirect_to url_for(:controller => 'users', :action => 'signin', :params => {:redirect_to => request.path }), status: :temporary_redirect
        }
        format.json {
          render status: :forbidden, nothing: true
        }
      end
      return
    end
  end

  def compile_info
    @page_title = "Compile Information of Run #{@status.runid}"
    respond_to do |format|
      format.html
      format.json {
        options = {}
        options[:only] = [:ce_info, :runid]
        render json: @status.to_json(options)
      }
    end
  end

  def show
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
  end

  # POST /statuses
  # POST /statuses.json
  def create
    create_params = status_params
    create_params[:username] = current_user.username
    create_params[:time_submit] = Time.now
    create_params[:result] = 'Waiting'
    create_params[:ipaddr] = request.remote_ip
    create_params[:jnum] = 0
    create_params[:contest_belong] = 0 if @contest && @contest.ended?

    @status = Status.new(create_params)
    if @status.save
      begin
        Problem.find(create_params[:pid])
        sock = TCPSocket.new OJ_CONFIG["contact"]["server"], OJ_CONFIG["contact"]["port"]
        sock.puts OJ_CONFIG["contact"]["string"]["submit"]
        sock.puts @status.runid
        sock.puts @problem.vname
        sock.close
        @problem.total_submit = @problem.total_submit + 1
        @problem.save
        current_user.total_submit = current_user.total_submit + 1
        current_user.save
      rescue
      end
      render json: { msg: "Submitted" }, status: :created
    else
      render json: { msg: @status.errors }, status: :unprocessable_entity
    end
  end

  def check_submit_valid
    begin
      raise 'Source code too long' if params[:status][:source].length > JS_CONFIG["limits"]["max_source_code_len"]
      begin
        @problem = Problem.find(params[:status][:pid])
      rescue
        raise 'No such problem'
      end
      if params[:status][:contest_belong].to_i == 0
        raise 'No such problem' if @problem.hide && !current_user.is_admin?
      else
        begin
          @contest = Contest.find(params[:status][:contest_belong].to_i)
        rescue
          raise 'No such contest'
        end
        raise 'User not in the contest' unless @contest.has_user(current_user.username)
        raise 'No such problem in this contest' if ContestProblem.where(cid: params[:status][:contest_belong].to_i, pid: params[:status][:pid].to_i).empty?
      end
      raise 'Please select language' if params[:status][:language].to_i == 0
      last_status = Status.where(username: current_user.username).order(time_submit: :desc).first
      raise 'Too fast' if Time.now - last_status.time_submit < 5
    rescue Exception => e
      render status: :not_acceptable, json: { msg: e.message }
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status ||= Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit([:pid, :source, :language, :isshared, :contest_belong])
    end

end
