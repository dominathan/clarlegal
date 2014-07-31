module ApplicationHelper

  def full_title(page_title)
    base_title = "ClarLegal"
    if page_title.empty?
      base_title
    else
      page_title == base_title ? base_title : "#{base_title} | #{page_title}"
    end
  end

  def is_active?(page_controller)
    controller.controller_name == page_controller ? "active" : ""
  end


end
