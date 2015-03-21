module NamesHelper
  class Name
    attr_reader :first_name, :middle_name, :last_name

    def initialize(first_name, middle_name=nil, last_name)
      @first_name, @middle_name, @last_name = first_name, middle_name, last_name
    end

    def full_name
      [first_name, middle_name, last_name].compact.join(" ")
    end

    def full_name_last_first
      last_name_first = [last_name, first_name, middle_name].compact
      if last_name_first.length > 2
        last_name_first[0..-2].join(", ")+(" ")+last_name_first[-1]
      else
        "#{last_name}, #{first_name}"
      end
    end
  end
end

