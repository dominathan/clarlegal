module FormHelper
  def setup_case(new_case)
    new_case.fee ||= Fee.new
    new_case
  end
end
