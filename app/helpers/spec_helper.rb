module SpecHelper
  def rand_in_range(from, to)
    rand * (to - from) + from
  end

  def rand_time(from, to=Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
  end
end
