module ProblemsHelper
  def pid_link_list(pids)
    html = "".html_safe
    pids.each do |pid|
      html << "<a href='#{problem_path pid}'>#{pid}</a>&nbsp; ".html_safe
    end
    return html
  end
end
