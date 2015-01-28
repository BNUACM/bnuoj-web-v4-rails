class ProblemsDatatable

  def initialize(view)
    @view = view
    @columns = %w[problem.pid problem.title problem.source problem.total_ac problem.total_submit problem.vacnum problem.vtotalnum problem.vacpnum problem.vtotalpnum problem.vname problem.vid]
    @model = Problem
  end

  def method_missing(meth, *args, &block)
    @view.send(meth, *args, &block)
  end

  # Override this to fit datatable format.
  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @model.count,
      iTotalDisplayRecords: records.total_entries,
      aaData: data
    }
  end

private

  def data
    pids = records.pluck(:pid)
    if logged_in?
      @submit_table = Status.where(username: current_user.username, pid: pids).group('pid').count
      @ac_table = Status.where(username: current_user.username, pid: pids, result: 'Accepted').group('pid').count
    else
      @submit_table = {}
      @ac_table = {}
    end
    records.map do |record|
      problem_flag = begin
        if !@ac_table[record.pid].nil?
          "Yes"
        elsif !@submit_table[record.pid].nil?
          "No"
        else
          ""
        end
      end
      [
        problem_flag,
        record.pid,
        record.title,
        record.source,
        record.total_ac,
        record.total_submit,
        record.vacnum,
        record.vtotalnum,
        record.vacpnum,
        record.vtotalpnum,
        record.vname,
        record.vid
      ]
    end
  end

  def records
    @records ||= fetch_records
  end

  def search_records(records)
    if params[:sSearch].present?
      query = @columns.map do |column|
        "#{column} LIKE :search"
      end.join(" OR ")
      records = records.where(query, search: "%#{params[:sSearch]}%")
    end

    @columns.each_index { |i|
      if params["bSearchable_#{i}"] == "true" && !params["sSearch_#{i}"].empty?
        records = records.where("#{@columns[i]} = ?", params["sSearch_#{i}"])
      end
    }

    records = records.user_unsolved(current_user.username) if params[:unsolved] == "1" && logged_in?
    return records
  end

  def fetch_records
    records = @model.public_problems.order("#{sort_column} #{sort_direction}")
    records = search_records(records)
    records = records.page(page).per_page(per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? [params[:iDisplayLength].to_i, 100].min : 10
  end

  def sort_column
    @columns[ [params[:iSortCol_0].to_i - 1, 0].max ]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end