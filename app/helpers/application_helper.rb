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

  def is_active_graph?(page_controller,action)
    if controller.controller_name == page_controller &&
                                    controller.action_name == action
      "active"
    else
      ""
    end
  end

  def is_active_for_drilldowns?(page_controller, action)
    if controller.controller_name == page_controller &&
                                    controller.action_name != action
      "active"
    else
      ""
    end
  end

  def graph_sidebar?(page_controller)
    if controller.controller_name == page_controller
      render 'shared/sidebar'
    end
  end


end
