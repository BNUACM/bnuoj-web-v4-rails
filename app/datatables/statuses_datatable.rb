class StatusesDatatable

  def initialize(view)
    @view = view
    @columns = %w[username runid pid result language time_used memory_used LENGTH(source) time_submit isshared]
    @model = Status.eager_load(:language_name)
  end

  def method_missing(meth, *args, &block)
    @view.send(meth, *args, &block)
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      # don't use count since it costs too much
      iTotalRecords: @model.last.runid,
      iTotalDisplayRecords: @model.last.runid,
      aaData: data
    }
  end

private

  def data
    records.map do |record|
      viewable = begin
        if !logged_in? || record.isshared
          record.isshared
        else
          if current_user.username.casecmp(record.username) == 0 || current_user.is_admin?
            true
          else
            false
          end
        end
      end
      [
        record.username,
        record.runid,
        record.pid,
        record.result,
        record.language_name.name,
        record.time_used,
        record.memory_used,
        record.source.length,
        record.time_submit_display,
        viewable
      ]
    end
  end

  def records
    @records ||= fetch_records
  end

  def search_records(records)
    @columns.each_index { |i|
      if params["bSearchable_#{i}"] == "true" && !params["sSearch_#{i}"].empty?
        records = records.where("#{@columns[i]} = ?", params["sSearch_#{i}"])
      end
    }
    return records
  end

  def fetch_records
    records = @model.public.order("status.runid DESC")
    records = search_records(records)
    # will_paginate will do count(*), so just use offset and limit here
    records = records.offset(offset).limit(per_page)
  end

  def offset
    params[:iDisplayStart].to_i
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? [params[:iDisplayLength].to_i, 100].min : 10
  end

end