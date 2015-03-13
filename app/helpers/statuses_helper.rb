module StatusesHelper
  def status_link(text, hsh)
    link_to text, statuses_path( hsh )
  end
end
