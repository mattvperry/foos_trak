module ApplicationHelper
  # Cannot find a place to put this =( (saving for later)
  def github_button(type)
    url = URI::HTTP.build({
      host: "ghbtns.com",
      path: "/github-btn.html",
      query: {
        user: :perrym5,
        repo: :foos_trak,
        type: type,
        count: true,
      }.to_query
    }).to_s

    haml_tag(:iframe, {
      src: url,
      allowtransparency: true,
      frameborder: 0,
      scrolling: 0,
      width: 95,
      height: 20
    })
  end

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

  def base_errors(resource)
    return nil if (resource.errors.empty?) or (resource.errors[:base].empty?)
    html = capture_haml do
      haml_concat "Please review the problems below:"
      haml_tag :ul do
        resource.errors[:base].each do |error|
          haml_tag :li, error
        end
      end
    end
  end
end
