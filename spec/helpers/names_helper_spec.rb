require 'names_helper.rb'

describe 'NamesHelper' do
  let(:name) { NamesHelper::Name.new("Nathan", "Michael", "Hall") }
  let(:name_without_middle) { NamesHelper::Name.new("Nathan", "Hall") }
  let(:name_with_two_middles) { NamesHelper::Name.new("Nathan", "Michael Wright", "Hall") }
  let(:name_with_initial_middles) { NamesHelper::Name.new("Nathan", "M.", "Hall") }

  it 'should return a full name' do
    expect(name.full_name).to eq("Nathan Michael Hall")
    expect(name_with_initial_middles.full_name).to eq("Nathan M. Hall")
    expect(name_without_middle.full_name).to eq("Nathan Hall")
    expect(name_with_two_middles.full_name).to eq("Nathan Michael Wright Hall")
  end

  it 'should return a full_name_last_first' do
    expect(name.full_name_last_first).to eq("Hall, Nathan Michael")
    expect(name_without_middle.full_name_last_first).to eq("Hall, Nathan")
    expect(name_with_two_middles.full_name_last_first).to eq("Hall, Nathan Michael Wright")
    expect(name_with_initial_middles.full_name_last_first).to eq("Hall, Nathan M.")
  end
end
