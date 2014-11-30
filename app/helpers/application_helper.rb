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

  #Render the shared/sidebar_actual if the page_controller is
  # graph/graph_drilldowns/graph_individual_prac_groups
  def graph_sidebar_projected?(page_controller)
    if controller.controller_name == page_controller
      render 'shared/sidebar_projected'
    end
  end

  #Render the shared/sidebar_actual if the page_controller is graph_actuals
  def graph_sidebar_actual?(page_controller)
    if controller.controller_name == page_controller
      render 'shared/sidebar_actual'
    end
  end

end
