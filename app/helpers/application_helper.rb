module ApplicationHelper
  def nav_link(text, path)
    class_name = current_page?(path) ? 'active' : ''

    content_tag :li, class: class_name do
      link_to text, path
    end
  end

  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info',
    }[flash_type.to_sym]
  end
end
