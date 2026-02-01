# ===========================================
# Application Helper
# ===========================================
module ApplicationHelper
  def page_title(title = nil)
    base_title = SiteSetting.get('site_name', 'Portfolio')
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def current_year
    Time.current.year
  end

  def format_date(date)
    return nil unless date
    date.strftime('%B %d, %Y')
  end

  def truncate_text(text, length = 100)
    return '' unless text
    text.truncate(length)
  end

  def active_link_class(path)
    request.path == path ? 'active' : ''
  end
end
