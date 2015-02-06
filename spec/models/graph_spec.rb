require 'spec_helper'

describe Graph do
  before { @lawfirm  = FactoryGirl.create(:lawfirm),
           @lawfirm1 = FactoryGirl.create(:lawfirm, id: 1),
           @lawfirm2 = FactoryGirl.create(:lawfirm, id: 2),

           @user1 = FactoryGirl.create(:user, lawfirm_id: 1, id: 1),
           @user2 = FactoryGirl.create(:user, lawfirm_id: 2),

           @prac1_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 1, id: 1, group_name: "test_group_1"),
           @prac2_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 1, id: 2, group_name: "test_group_2"),
           @prac3_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 1, id: 3, group_name: "test_group_3"),
           @prac4_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 2),
           @prac5_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 2),
           @prac6_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 2),

           @client1 = FactoryGirl.create(:client, user_id: 1, id: 1),
           @client2 = FactoryGirl.create(:client, user_id: 1, id: 2),
           @client3 = FactoryGirl.create(:client, user_id: 1, id: 3)
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

  describe 'actual amounts' do

     before { @time = Date.parse("Jan 1 2015")
             Date.stub!(:today).and_return(@time)
             @case1 = FactoryGirl.create(:case, client_id: 1, id: 1),
             @closeout1 = FactoryGirl.create(:closeout, case_id: 1, date_fee_received: Date.today ),
             @case2 = FactoryGirl.create(:case, client_id: 1, id: 2),
             @closeout2 = FactoryGirl.create(:closeout, case_id: 2, date_fee_received: Date.today - 1.years ),
             @case3 = FactoryGirl.create(:case, client_id: 1, id: 3),
             @closeout3 = FactoryGirl.create(:closeout, case_id: 3, date_fee_received: Date.today - 2.years),
             @case4 = FactoryGirl.create(:case, client_id: 2, id: 4),
             @closeout4 = FactoryGirl.create(:closeout, case_id: 4, date_fee_received: Date.today - 3.years),
             @case5 = FactoryGirl.create(:case, client_id: 2, id: 5),
             @closeout5 = FactoryGirl.create(:closeout, case_id: 5, date_fee_received: Date.today - 4.years),
             @case6 = FactoryGirl.create(:case, client_id: 2, id: 6),
             @closeout6 = FactoryGirl.create(:closeout, case_id: 6, date_fee_received: Date.today - 5.years),
             @case7 = FactoryGirl.create(:case, client_id: 3, id: 7),
             @closeout7 = FactoryGirl.create(:closeout, case_id: 7 , date_fee_received: Date.today - 1.years),
             @case8 = FactoryGirl.create(:case, client_id: 3, id: 8),
             @closeout8 = FactoryGirl.create(:closeout, case_id: 8, date_fee_received: Date.today - 2.years),
             @case9 = FactoryGirl.create(:case, client_id: 3, id: 9),
             @closeout9 = FactoryGirl.create(:closeout, case_id: 9, date_fee_received: Date.today - 1.years)
           }

    context 'closeout years' do
      subject { Graph.closeout_years }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([Date.today - 4.years, Date.today - 3.years,
                      Date.today - 2.years, Date.today - 1.years,
                      Date.today])
          }
    end

    context 'closeout_year_only' do
      subject { Graph.closeout_year_only}
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([Date.today.year - 4, Date.today.year - 3,
                      Date.today.year - 2, Date.today.year - 1,
                      Date.today.year])
          }
    end

    context 'Graph.closeout_amount_by_year(@user1, total_fee_received)' do
      subject { Graph.closeout_amount_by_year(@user1,'total_fee_received') }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([1,1,2,3,1])}

      it 'should not include cases with date_fee_received 5 or more years ago' do
        @closeout1.update_attribute(:date_fee_received, Date.today - 5.years)
        expect(Graph.closeout_amount_by_year(@user1,'total_fee_received')).to eq([1,1,2,3,0])
      end

      it 'adding a case with a closeout.total_fee_received of 100 will appear in the right date' do
        @case10 = FactoryGirl.create(:case, client_id: 3, id: 10)
        @closeout100 = FactoryGirl.create(:closeout, case_id: 10, date_fee_received: Date.today - 2.years,
                                          total_fee_received: 100)
        expect(Graph.closeout_amount_by_year(@user1,'total_fee_received')).to eq([1,1,102,3,1])
      end

      it 'should not sum cases belonging to other lawfirms' do
        @client4 = FactoryGirl.create(:client, user_id: 2, id: 4)
        @case10 = FactoryGirl.create(:case, client_id: 4, id: 10)
        @closeout100 = FactoryGirl.create(:closeout, case_id: 10, date_fee_received: Date.today - 2.years,
                                          total_fee_received: 100)
        expect(Graph.closeout_amount_by_year(@user1,'total_fee_received')).to eq([1,1,2,3,1])
      end
    end

    context "Graph.closeout_amount_by_year(@user1, total_fee_received) do" do
      subject { Graph.closeout_amount_by_year(@user1, 'total_recovery') }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([5,5,10,15,5])}
    end

    context "Graph.closeout_amount_by_year(@user1, total_gross_fee_received) do" do
      subject { Graph.closeout_amount_by_year(@user1, 'total_gross_fee_received') }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([4,4,8,12,4])}
    end

    context "Graph.closeout_amount_by_year(@user1, total_out_of_pocket_expenses) do" do
      subject { Graph.closeout_amount_by_year(@user1, 'total_out_of_pocket_expenses') }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([3,3,6,9,3])}
    end

    context "Graph.closeout_amount_by_year(@user1, referring_fees_paid) do" do
      subject { Graph.closeout_amount_by_year(@user1, 'referring_fees_paid') }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([2,2,4,6,2])}
    end

    context 'Graph.set_months' do
      subject { Graph.set_months }
      it { should be_a(Array) }
      it { should have(12).items }
      test_month = Date.today.beginning_of_year
      it { should eq([test_month, test_month + 1.month, test_month + 2.month, test_month + 3.month,
                      test_month + 4.month,test_month + 5.month,test_month + 6.month,test_month + 7.month,
                      test_month + 8.month,test_month + 9.month,test_month + 10.month,test_month + 11.month])
          }

      it 'changing the year should be reflected' do
        test_month_year = Graph.set_months(-1)
        expect(test_month_year[0].year).to eq(Date.today.year - 1)
      end
    end

    context 'Graph.closeout_amount_by_month_by_year(user,closeout_amount,year_to_add)' do
      subject { Graph.closeout_amount_by_month_by_year(@user1,'total_fee_received',0) }
      it { should be_a(Array) }
      it { should have(12).items }
      it { should eq(Array.new(11,0).prepend(1)) }
    end
  end
end
