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

  # # GET /problems/new
  # def new
  #   @problem = Problem.new
  # end

  # # GET /problems/1/edit
  # def edit
  # end

  # # POST /problems
  # # POST /problems.json
  # def create
  #   @problem = Problem.new(problem_params)

  #   respond_to do |format|
  #     if @problem.save
  #       format.html { redirect_to @problem, notice: 'Problem was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @problem }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @problem.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /problems/1
  # # PATCH/PUT /problems/1.json
  # def update
  #   respond_to do |format|
  #     if @problem.update(problem_params)
  #       format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @problem.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /problems/1
  # # DELETE /problems/1.json
  # def destroy
  #   @problem.destroy
  #   respond_to do |format|
  #     format.html { redirect_to problems_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params[:problem]
    end
end
