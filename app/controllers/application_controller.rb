class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def belongs_to_firm
      unless current_user.lawfirm
        redirect_to new_user_lawfirm_path(current_user.id)
        flash[:danger] = "You must join or create a lawfirm."
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, :flash => { :danger => "You must sign in."}
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #To be used on graph_actuals controller to prevent people from viewing information with no closed cases.
    def has_closed_cases
      unless current_user.lawfirm.cases.where(open: false).exists?
        redirect_to new_closed_case_path,
          :flash => {:danger => "You must fill out or upload information of a closed case to view."}
      end
    end

    #To be used on graph, graph_drilldowns, and graph_individual_prac_groups controller
    # to prevent people from viewing information with no open cases.
    def has_open_cases
      unless current_user.lawfirm.cases.where(open: true).exists?
        redirect_to new_case_path,
          :flash => {:danger => "You must fill out or upload information of an open case to view."}
      end
    end

    #If a controller method uses overhead in calculating something, we need to be sure overhead is set
    def has_overhead_last_5_years
      if current_user.lawfirm.overheads
        ovh = current_user.lawfirm.overheads.collect(&:year)
        if ovh.include?(Date.today.year) and ovh.include?(Date.today.year - 1) and ovh.include?(Date.today.year - 2) and ovh.include?(Date.today.year - 3) and ovh.include?(Date.today.year - 4)
           return true
         else
          redirect_to user_lawfirm_overheads_path(current_user, current_user.lawfirm_id),
            :flash => {:danger => "You must calculate overhead for each of the past 5 years to view this page."}
        end
      else
        redirect_to user_lawfirm_overheads_path(current_user, current_user.lawfirm_id),
          :flash => {:danger => "You must calculate overhead for each of the past 5 years to view this page."}
      end
    end

    def has_overhead_last_year
      if current_user.lawfirm.overheads
        ovh = current_user.lawfirm.overheads.collect(&:year)
        if ovh.include?(Date.today.year)
          return true
        else
          redirect_to user_lawfirm_overheads_path(current_user, current_user.lawfirm_id),
            :flash => {:danger => "You must add ESTIMATED overhead for this year."}
        end
      else
        redirect_to user_lawfirm_overheads_path(current_user, current_user.lawfirm_id),
          :flash => {:danger => "You must add ESTIMATED overhead for this year."}
      end
    end

    def set_case
      @case = Case.find(params[:case_id])
    end

    def set_client
      @client = Client.find(params[:client_id])
    end

    def set_lawfirm
      @lawfirm = Lawfirm.find_by(id: current_user.lawfirm.id)
    end

end
