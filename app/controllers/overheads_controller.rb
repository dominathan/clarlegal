class OverheadsController < ApplicationController

  def index
    @overheads = current_user.lawfirm.overheads.order(:year).reverse
  end

  def new
    @overhead = Overhead.new
  end

  #Create overhead rate per hour which is (total indirect costs)/(total billable hours)
  #current_user.lawfirm.staffings.count should only be if they do not provide a number of billable staff
  def create
    @overhead = Overhead.new(overhead_params)
    total_billable_staff = @overhead.number_of_billable_staff || current_user.lawfirm.staffings.count
    @overhead.rate_per_hour = ((@overhead.rent + @overhead.utilities + @overhead.hard_costs +
                                @overhead.guaranteed_salaries + @overhead.other).to_f /
                                (@overhead.billable_hours_per_lawyer * total_billable_staff)
                                ).round(2)
    @overhead.lawfirm_id = current_user.lawfirm.id
    if @overhead.save
      flash[:success] = "Overhead Added Successfully"
      redirect_to user_lawfirm_overheads_path(current_user, current_user.lawfirm)
    else
      render 'new'
    end
  end

  def edit
    @overhead = Overhead.find(params[:id])
  end

  def update
    @overhead = Overhead.find(params[:id])
    if @overhead.update_attributes(overhead_params)
      total_billable_staff = @overhead.number_of_billable_staff || current_user.lawfirm.staffings.count
      @overhead.rate_per_hour = ((@overhead.rent + @overhead.utilities + @overhead.hard_costs +
                                @overhead.guaranteed_salaries + @overhead.other).to_f /
                                (@overhead.billable_hours_per_lawyer * total_billable_staff)
                                ).round(2)
      @overhead.save
      flash[:success] = "Updated Overhead Successfully"
      redirect_to user_lawfirm_overheads_path(current_user.id, current_user.lawfirm.id)
    else
      render 'edit'
    end
  end

  def show
    @overhead = Overhead.find_by(id: current_user.lawfirm.overheads.order(:created_at).last)
  end

  private

    def overhead_params
      params.require(:overhead).permit(:rent, :utilities, :technology,
                                       :hard_costs, :guaranteed_salaries, :other,
                                       :billable_hours_per_lawyer, :number_of_billable_staff,
                                       :year)
    end

end
