class ContestsDatatable

  def initialize(view)
    @view = view
    @columns = %w[contest.cid contest.title contest.start_time contest.end_time contest.isprivate contest.owner contest.isvirtual contest.type]
    @model = Contest
  end

  def method_missing(meth, *args, &block)
    @view.send(meth, *args, &block)
  end

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
    records.map do |record|
      [
        record.cid,
        record.title,
        record.start_time_display,
        record.final_time_display,
        record.status_text,
        record.access_text,
        record.owner,
        record.isvirtual,
        record.type
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
        if @columns[i] == "contest.type" && params["sSearch_#{i}"] == "-99"
          # hack for non-replay contests
          records = records.where("#{@columns[i]} != 99")
        else
          records = records.where("#{@columns[i]} = ?", params["sSearch_#{i}"])
        end
      end
    }

    return records
  end

  def fetch_records
    records = @model.order("#{sort_column} #{sort_direction}")
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
    @columns[ [params[:iSortCol_0].to_i, 0].max ]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end