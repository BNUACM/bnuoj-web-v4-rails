class ProblemsController < ApplicationController
  # before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :check_visibility, only: [:show]

  # # GET /problems
  # # GET /problems.json
  def index
    @page_title = "Problem List"
    respond_to do |format|
      format.html
      format.json {
        render json: ProblemsDatatable.new(view_context)
      }
    end
  end

  # Check if the current problem is visible to current user.
  def check_visibility
    set_problem
    viewable = begin
      unless @problem.hide
        true
      else
        if logged_in? && current_user.is_admin?
          true
        else
          false
        end
      end
    end

    unless viewable
      render status: :forbidden, nothing: true
      return
    end
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
    @page_title = "BNUOJ #{@problem.pid} - #{@problem.title}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def problem_params
      params[:problem]
    end
end
