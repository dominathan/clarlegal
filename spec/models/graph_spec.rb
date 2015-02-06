require 'spec_helper'

describe Graph do
  before { @lawfirm  = FactoryGirl.create(:lawfirm),
           @lawfirm1 = FactoryGirl.create(:lawfirm, id: 1),
           @lawfirm2 = FactoryGirl.create(:lawfirm, id: 2),

           @user1 = FactoryGirl.create(:user, lawfirm_id: 1),
           @user2 = FactoryGirl.create(:user, lawfirm_id: 2),

           @prac1_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 1, id: 1, group_name: "test_group_1"),
           @prac2_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 1, id: 2, group_name: "test_group_2"),
           @prac3_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 1, id: 3, group_name: "test_group_3"),
           @prac4_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 2),
           @prac5_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 2),
           @prac6_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 2)
         }

  context 'when calling Graph.user_practice_groups' do
    it 'should have only practicegroups of the first lawfirm' do
      expect(Graph.user_practice_groups(@user1)).to eq(["test_group_3","test_group_2","test_group_1"])
    end
  end

  context 'when calling Graph.user_practice_group_ids' do
    it 'should return 1,2,3' do
      expect(Graph.user_practice_group_ids(@user1)).to eq([3,2,1])
    end
  end

  context 'when adding arrays' do
    it 'should add them correctly' do
      @array1 = [1,2,3]
      @array2 = [1,2,3]
      expect(Graph.add_arrays(@array1,@array2)).to eq([2,4,6])
    end
  end

  context 'when subtracting array' do
    it 'should subtract them correctly' do
      @array1 = [1,2,3]
      @array2 = [1,2,3]
      expect(Graph.subtract_arrays(@array1,@array2)).to eq([0,0,0])
    end
  end

  context 'when removing items less than from an array' do
    it 'should remove items less than or equal to specified amount' do
      @array1 = [1,2,3]
      @items = Graph.user_practice_groups(@user1).zip(@array1)
      expect(Graph.remove_arrays_less_than_or_equal_to(@items,2)).to eq([['test_group_1',3]])
      expect(Graph.remove_arrays_less_than_or_equal_to(@items,2)).to_not eq([['test_group_1',3],["test_group_2",2],["test_group_1",1]])
    end
  end


end
