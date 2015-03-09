require 'spec_helper'

describe Graph do
  before { @lawfirm  = FactoryGirl.create(:lawfirm),
           @lawfirm1 = FactoryGirl.create(:lawfirm, id: 111),
           @lawfirm2 = FactoryGirl.create(:lawfirm, id: 222),

           @user1 = FactoryGirl.create(:user, lawfirm_id: 111, id: 1),
           @user2 = FactoryGirl.create(:user, lawfirm_id: 222, id: 2),

           @prac1_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 111, id: 1, group_name: "test_group_1"),
           @prac2_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 111, id: 2, group_name: "test_group_2"),
           @prac3_firm1 = FactoryGirl.create(:practicegroup, lawfirm_id: 111, id: 3, group_name: "test_group_3"),
           @prac4_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 222, id: 4),
           @prac5_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 222, id: 5),
           @prac6_firm2 = FactoryGirl.create(:practicegroup, lawfirm_id: 222, id: 6),

           @client1 = FactoryGirl.create(:client, user_id: 1, id: 1)
           @client2 = FactoryGirl.create(:client, user_id: 1, id: 2)
           @client3 = FactoryGirl.create(:client, user_id: 1, id: 3)
           @client4 = FactoryGirl.create(:client, user_id: 2, id: 999)
         }

  context 'when calling Graph.user_practice_groups' do
    it 'should have only practicegroups of the first lawfirm' do
      expect(Graph.user_practice_groups(@user1).sort).to eq(["test_group_1","test_group_2","test_group_3"])
    end
  end

  context 'when calling Graph.user_practice_group_ids' do
    it 'should return 1,2,3' do
      expect(Graph.user_practice_group_ids(@user1).sort).to eq([1,2,3])
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
      @items = Graph.user_practice_groups(@user1).sort.reverse.zip(@array1)
      expect(Graph.remove_arrays_less_than_or_equal_to(@items,2)).to eq([['test_group_1', 3]])
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
             @case4 = FactoryGirl.create(:case, client_id: 2, id: 4, practicegroup_id: 2),
             @closeout4 = FactoryGirl.create(:closeout, case_id: 4, date_fee_received: Date.today - 3.years),
             @case5 = FactoryGirl.create(:case, client_id: 2, id: 5, practicegroup_id: 2),
             @closeout5 = FactoryGirl.create(:closeout, case_id: 5, date_fee_received: Date.today - 4.years),
             @case6 = FactoryGirl.create(:case, client_id: 2, id: 6, practicegroup_id: 2),
             @closeout6 = FactoryGirl.create(:closeout, case_id: 6, date_fee_received: Date.today - 5.years),
             @case7 = FactoryGirl.create(:case, client_id: 3, id: 7, practicegroup_id: 3),
             @closeout7 = FactoryGirl.create(:closeout, case_id: 7 , date_fee_received: Date.today - 1.years),
             @case8 = FactoryGirl.create(:case, client_id: 3, id: 8, practicegroup_id: 3),
             @closeout8 = FactoryGirl.create(:closeout, case_id: 8, date_fee_received: Date.today - 2.years),
             @case9 = FactoryGirl.create(:case, client_id: 3, id: 9, practicegroup_id: 3),
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

      it 'changing a @closeout1 to february will show up in the second slot february' do
        @closeout1.update_attribute(:date_fee_received, @closeout1.date_fee_received + 1.month)
        expect(Graph.closeout_amount_by_month_by_year(@user1,'total_fee_received',0)).to eq([0,1,0,0,0,0,0,0,0,0,0,0])
      end

      it 'subtracting 1 year should grab @closeout2, 7 and 9 and have 3 in the month of january' do
        expect(Graph.closeout_amount_by_month_by_year(@user1,'total_fee_received',-1)).to eq([3,0,0,0,0,0,0,0,0,0,0,0])
      end
    end

    before {    @ovh1 = FactoryGirl.create(:overhead, year: Date.today.year, lawfirm_id: 111),
                @ovh2 = FactoryGirl.create(:overhead, year: Date.today.year - 1, lawfirm_id: 111),
                @ovh3 = FactoryGirl.create(:overhead, year: Date.today.year - 2, lawfirm_id: 111),
                @ovh4 = FactoryGirl.create(:overhead, year: Date.today.year - 3, lawfirm_id: 111),
                @ovh5 = FactoryGirl.create(:overhead, year: Date.today.year - 4, lawfirm_id: 111)
            }

    context "Graph.total_overhead_per_year(user)" do

      subject { Graph.total_overhead_per_year(@user1) }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq(Array.new(5,3000000)) }
      it 'adding 2000000 to utiltiies in current year should show up last' do
        Overhead.find_by(year: Date.today.year).update_attribute(:utilities, 2000000)
        expect(Graph.total_overhead_per_year(@user1)).to eq(Array.new(4,3000000).append(5000000))
      end
    end

    before {
            @orig1 = FactoryGirl.create(:origination, case_id: 1,:referral_source => "source1")
            @orig2 = FactoryGirl.create(:origination, case_id: 2,:referral_source => "source2")
            @orig3 = FactoryGirl.create(:origination, case_id: 3,:referral_source => "source3")
            @orig4 = FactoryGirl.create(:origination, case_id: 4,:referral_source => "source1")
            @orig5 = FactoryGirl.create(:origination, case_id: 5,:referral_source => "source2")
            @orig6 = FactoryGirl.create(:origination, case_id: 6,:referral_source => "source3")
            @orig7 = FactoryGirl.create(:origination, case_id: 7,:referral_source => "source1")
            @orig8 = FactoryGirl.create(:origination, case_id: 8,:referral_source => "source2")
            @orig9 = FactoryGirl.create(:origination, case_id: 9,:referral_source => "source3")
    }

    context "Graph.closeout_amount_by_origination(user,referral_source,closeout_amount,test_year=3)" do
      subject { Graph.closeout_amount_by_origination(@user1,'source3',"total_fee_received",3) }
      it { should be_a(Integer) }
      it { should eq(2)   }

      it 'changing the amount won on a case should show up in the origination' do
        @closeout3.update_attribute(:total_fee_received, 100)
        expect(Graph.closeout_amount_by_origination(@user1,'source3',"total_fee_received",3)).to eq(101)
      end

      it 'changing :date_fee_received to longer than the N years ago should not include it anymore' do
        @closeout3.update_attribute(:total_fee_received, 100)
        @closeout3.update_attribute(:date_fee_received, Date.today - 10.years)
        expect(Graph.closeout_amount_by_origination(@user1,'source3',"total_fee_received",3)).to eq(1)
      end
    end

    context 'Graph.closed_cases_after(user,test_year=3)' do
      subject { Graph.closed_cases_after(@user1).sort }
      it { should be_a(Array) }
      it { should eq([['test_group_1',3],['test_group_2',0],['test_group_3',3]])}

      it 'only looking back one year will show 1 year from todays date' do
        expect(Graph.closed_cases_after(@user1,1).sort).to eq([["test_group_1", 1],["test_group_2", 0],["test_group_3", 0]])
      end

      it 'adding a new closedcase should show up' do
        @case10 = FactoryGirl.create(:case, id: 444, client_id: 1, practicegroup_id: 1)
        @closeout10 = FactoryGirl.create(:closeout, case_id: 444, date_fee_received: Date.today)
        expect(Graph.closed_cases_after(@user1,1).sort).to eq([["test_group_1", 2],["test_group_2", 0],["test_group_3", 0]])
      end
    end

    context 'Graph.closed_cases_by_pg_and_closeout_type(user,closeout_amount,test_year=3)' do
      subject { Graph.closed_cases_by_pg_and_closeout_type(@user1,'total_fee_received', 1).sort }
      it { should be_a(Array) }
      it { should eq([["test_group_1", 1],["test_group_2", 0],["test_group_3", 0]])}

      it 'changing the number of years looked back will include other amount' do
        expect(Graph.closed_cases_by_pg_and_closeout_type(@user1,'total_fee_received', 2).sort).to eq([["test_group_1", 2],["test_group_2", 0],["test_group_3", 2]])
      end

      it 'changing the closeout_attribute will sum correctly' do
        expect(Graph.closed_cases_by_pg_and_closeout_type(@user1,'total_recovery', 1).sort).to eq([["test_group_1", 5],["test_group_2", 0],["test_group_3", 0]])
      end

      it 'adding a practicegroup will show up for the right lawfirm' do
        @pg4 = FactoryGirl.create(:practicegroup, lawfirm_id: 111, group_name: "IMHERE", id: 123456)
        expect(Graph.closed_cases_by_pg_and_closeout_type(@user1,'total_recovery', 1).sort).to eq([["IMHERE",0],["test_group_1", 5],["test_group_2", 0],["test_group_3", 0]])
      end

      it 'adding a practicegroup will NOT show up for the WRONG lawfirm' do
        @pg4 = FactoryGirl.create(:practicegroup, lawfirm_id: 222, group_name: "IMHERE", id: 24)
        expect(Graph.closed_cases_by_pg_and_closeout_type(@user1,'total_recovery', 1).sort).to eq([["test_group_1", 5],["test_group_2", 0],["test_group_3", 0]])
      end
    end

    context 'Graph.revenue_by_practice_group_actual(user,closeout_amount)' do
      subject { ActiveSupport::JSON.decode(Graph.revenue_by_practice_group_actual(@user1,"total_fee_received")) }
      it { should match_array([{"name" => "test_group_3", "data" => [0,0,1,2,0]},{"name" => "test_group_2", "data" => [1,1,0,0,0]},{"name" => "test_group_1", "data" => [0,0,1,1,1]}]) }

      it 'changing closeout_amount to "total_recovery" will multiply by 5' do
        expect(ActiveSupport::JSON.decode(Graph.revenue_by_practice_group_actual(@user1,"total_recovery")))
              .to match_array([{"name" => "test_group_3", "data" => [0,0,5,10,0]},{"name" => "test_group_2", "data" => [5,5,0,0,0]},{"name" => "test_group_1", "data" => [0,0,5,5,5]}])
      end

      it 'a new practicegroup will show up' do
        @pg4 = FactoryGirl.create(:practicegroup, lawfirm_id: 111, group_name: "IMHERE", id: 44)
        expect(ActiveSupport::JSON.decode(Graph.revenue_by_practice_group_actual(@user1,"total_recovery")))
              .to match_array([{"name" => "IMHERE", "data" => [0,0,0,0,0]},{"name" => "test_group_3", "data" => [0,0,5,10,0]},{"name" => "test_group_2", "data" => [5,5,0,0,0]},{"name" => "test_group_1", "data" => [0,0,5,5,5]}])
      end

      it 'a new closed case will show up at the right date' do
        @pg4 = FactoryGirl.create(:practicegroup, lawfirm_id: 111, group_name: "IMHERE", id: 444)
        @case10 = FactoryGirl.create(:case, client_id: 1, practicegroup_id: 444, id: 444)
        @closeout10 = FactoryGirl.create(:closeout, case_id: 444, total_recovery: 500, date_fee_received: Date.today - 2.years)
        expect(ActiveSupport::JSON.decode(Graph.revenue_by_practice_group_actual(@user1,"total_recovery")))
              .to match_array([{"name" => "IMHERE", "data" => [0,0,500,0,0]},{"name" => "test_group_3", "data" => [0,0,5,10,0]},{"name" => "test_group_2", "data" => [5,5,0,0,0]},{"name" => "test_group_1", "data" => [0,0,5,5,5]}])
      end
    end

    context 'Graph.revenue_by_fee_type_actual(user,fee_type,closeout_amount)' do
      subject { Graph.revenue_by_fee_type_actual(@user1,'Contingency','total_fee_received') }
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([1,1,2,3,1])}

      before { @case10 = FactoryGirl.create(:case, client_id: 1, practicegroup_id: 444, id: 444)
               @closeout10 = FactoryGirl.create(:closeout, case_id: 444, total_recovery: 500,
                                                date_fee_received: Date.today - 2.years, fee_type: "Mixed")
             }

      it 'adding a Mixed FeeType will not show up in contingency' do
        expect(Graph.revenue_by_fee_type_actual(@user1,'Contingency','total_recovery')).to eq([5,5,10,15,5])
      end

      it 'adding Mixed Fee Type will show up in Mixed' do
        expect(Graph.revenue_by_fee_type_actual(@user1,'Mixed','total_recovery')).to eq([0,0,500,0,0])
      end
    end

    context 'Graph.closeout_by_year_pg(user,pg,closeout_amount)' do
      subject { Graph.closeout_by_year_pg(@user1,1,'total_fee_received')}
      it { should be_a(Array) }
      it { should have(5).items }
      it { should eq([0,0,1,1,1]) }

      it 'changing the practice group will change the amounts' do
        expect(Graph.closeout_by_year_pg(@user1,3,'total_fee_received')).to eq([0,0,1,2,0])
      end

      before { @pracgroup7 = FactoryGirl.create(:practicegroup, lawfirm_id: 111,
                                                group_name: "test_group_444", id: 444)
               @not_this_prac_group = FactoryGirl.create(:practicegroup,
                                                         lawfirm_id: 222, group_name: "Not Me",id: 333)
               @case11 = FactoryGirl.create(:case, practicegroup_id: 444, client_id: 1, id: 444)
               @closeout11 = FactoryGirl.create(:closeout, case_id: 444, total_recovery: 500,
                                                date_fee_received: Date.today - 2.years)
               @case12 = FactoryGirl.create(:case, practicegroup_id: 333, client_id: 999, id: 333)
               @closeout12 = FactoryGirl.create(:closeout, case_id: 333, total_recovery: 500,
                                                date_fee_received: Date.today - 1.years)
             }

      it "Graph.closeout_by_year_pg(@user1,444,'total_recovery')" do
        expect(Graph.closeout_by_year_pg(@user1,444,'total_recovery')).to eq([0,0,500,0,0])
        expect(Graph.closeout_by_year_pg(@user1,444,'total_recovery')).to_not eq([0,0,500,500,0])
      end

      it "Graph.closeout_by_year_pg(@user2,333,'total_recovery')" do
        expect(Graph.closeout_by_year_pg(@user2,333,'total_recovery')).to eq([0,0,0,500,0])
      end
    end

    context 'Graph.all_origination_source_rev_pg(user,pg,closeout_amount)' do
      subject { Origination.all_referral_sources(@user1).sort }
      it { should be_a(Array) }
      it { should have(8).items }
      it { should eq(["Advertising", "Attorney", "Client", "Internet", "Reputation", "source1","source2","source3"])}
    end

    context 'Graph.revenue_by_origination_pg(user,pg,all_referral_sources[i],closeout_amount)' do
      subject { Graph.revenue_by_origination_pg(@user1,1,'source1','total_fee_received') }
      it { should be_a(Integer) }
      it { should eq(1)}
    end

    context 'Graph.all_origination_source_rev_pg(user,pg,closeout_amount)' do
      subject { Graph.all_origination_source_rev_pg(@user1,1,'total_fee_received').sort }
      it { should be_a(Array) }
      it { should have(8).items }
      it { should eq([["Advertising",0],["Attorney",0],["Client",0],["Internet",0],
                      ["Reputation",0],["source1",1],["source2",1],["source3",1]])
          }

      it "adding a new case with a new origination source will appear" do
        @casee11 = FactoryGirl.create(:case, id: 444, client_id: 1, practicegroup_id: 1)
        @closeout11 = FactoryGirl.create(:closeout, case_id: 444, fee_type: "Mixed", total_fee_received: 500)
        @orig11 = FactoryGirl.create(:origination, case_id: 444, id: 2, referral_source: "IM HERE")

        expect(Graph.all_origination_source_rev_pg(@user1,1,'total_fee_received').sort).to eq([
          ["Advertising",0],["Attorney",0],["Client",0],["IM HERE",500],["Internet",0],
          ["Reputation",0],["source1",1],["source2",1],["source3",1]])
      end
    end

    context 'Graph.rev_by_fee_type_pg(user,pg,closeout_amount)' do
      subject { ActiveSupport::JSON.decode(Graph.rev_by_fee_type_pg(@user1,1,"total_fee_received")) }
      it { should be_a(Array) }
      it { should eq([{'name' => "Contingency", 'data' => [0, 0, 1, 1, 1]}])}

      it 'adding another case with diff feetype will show up' do
        @case10 = FactoryGirl.create(:case, client_id: 1, practicegroup_id: 1, id: 575)
        @closeout10 = FactoryGirl.create(:closeout, case_id: 575, fee_type: "SHOW ME", total_fee_received: 500)
        expect(ActiveSupport::JSON.decode(Graph.rev_by_fee_type_pg(@user1,1,"total_fee_received"))).to eq(
          [{'name' => "Contingency", 'data' => [0, 0, 1, 1, 1]},
           {'name' => "SHOW ME", 'data' => [0, 0, 0, 0, 500]}])
      end
    end
  end

  describe 'expected / projected amounts' do
    before {
            @clcase1 = FactoryGirl.create(:case, open: true, client_id: 1, id: 21, practicegroup_id: 1)
            @clcase2 = FactoryGirl.create(:case, open: true, client_id: 1, id: 22, practicegroup_id: 1)
            @clcase3 = FactoryGirl.create(:case, open: true, client_id: 1, id: 23, practicegroup_id: 1)
            @clcase4 = FactoryGirl.create(:case, open: true, client_id: 2, id: 24, practicegroup_id: 2)
            @clcase5 = FactoryGirl.create(:case, open: true, client_id: 2, id: 25, practicegroup_id: 2)
            @clcase6 = FactoryGirl.create(:case, open: true, client_id: 2, id: 26, practicegroup_id: 2)
            @clcase7 = FactoryGirl.create(:case, open: true, client_id: 3, id: 27, practicegroup_id: 3)
            @clcase8 = FactoryGirl.create(:case, open: true, client_id: 3, id: 28, practicegroup_id: 3)
            @clcase9 = FactoryGirl.create(:case, open: true, client_id: 3, id: 29, practicegroup_id: 3)
            @fee1 = FactoryGirl.create(:fee, case_id: 21)
            @fee2 = FactoryGirl.create(:fee, case_id: 22)
            @fee3 = FactoryGirl.create(:fee, case_id: 23)
            @fee4 = FactoryGirl.create(:fee, case_id: 24)
            @fee5 = FactoryGirl.create(:fee, case_id: 25)
            @fee6 = FactoryGirl.create(:fee, case_id: 26)
            @fee7 = FactoryGirl.create(:fee, case_id: 27)
            @fee8 = FactoryGirl.create(:fee, case_id: 28)
            @fee9 = FactoryGirl.create(:fee, case_id: 29)
            @timing1 = FactoryGirl.create(:timing, case_id: 21)
            @timing2 = FactoryGirl.create(:timing, case_id: 22)
            @timing3 = FactoryGirl.create(:timing, case_id: 23)
            @timing4 = FactoryGirl.create(:timing, case_id: 24)
            @timing5 = FactoryGirl.create(:timing, case_id: 25)
            @timing6 = FactoryGirl.create(:timing, case_id: 26)
            @timing7 = FactoryGirl.create(:timing, case_id: 27)
            @timing8 = FactoryGirl.create(:timing, case_id: 28)
            @timing9 = FactoryGirl.create(:timing, case_id: 29)
    }

    context 'a new case' do
      subject { @clcase1 }
      it { should be_a(Case) }

      it 'should respond to the case attributes' do
        expect(@clcase1.open).to eq(true)
        expect(@clcase2.fees.first.high_estimate).to be(5)
        expect(@clcase9.timings.first.estimated_conclusion_fast).to be_a(Date)
      end
    end

    context 'Graph.expected_years' do
      subject { Graph.expected_years }
      it { should be_a(Array) }
      it { should eq([Date.today, Date.today + 1.year, Date.today + 2.years,
                      Date.today + 3.years, Date.today + 4.years])
          }
    end

    context 'Graph.fee_estimate_by_year(user,timing_estimate,fee_estimate)' do

      subject { Graph.fee_estimate_by_year(@user1,'estimated_conclusion_fast',"high_estimate")}
      it { should eq([45,0,0,0,0]) }

      it 'should accept different estimates' do
        expect(Graph.fee_estimate_by_year(@user1,'estimated_conclusion_slow',"medium_estimate")).to eq([0,0,27,0,0])
      end

      it 'should respond to updated fees from user' do
        @fee11 = FactoryGirl.create(:fee, case_id: 21, high_estimate: 1, medium_estimate: 0, low_estimate: 0)
        expect(Graph.fee_estimate_by_year(@user1,'estimated_conclusion_fast',"high_estimate")).to eq([41,0,0,0,0])
      end

      it 'should react to new timings' do
        @fee11 = FactoryGirl.create(:fee, case_id: 21, high_estimate: 1, medium_estimate: 0, low_estimate: 0)
        @timing11 = FactoryGirl.create(:timing, case_id: 21, estimated_conclusion_fast: Date.today + 4.years,
                                                        estimated_conclusion_expected: Date.today + 5.years,
                                                        estimated_conclusion_slow: Date.today + 6.years )
        expect(Graph.fee_estimate_by_year(@user1,'estimated_conclusion_fast',"high_estimate")).to eq([40,0,0,0,1])
      end
    end

    context 'Graph.fee_estimate_by_month(user,timing_estimate,fee_estimate,year_to_add)' do
      subject { Graph.fee_estimate_by_month(@user1,'estimated_conclusion_fast','low_estimate',0)}
      it { should have(12).items }
      it { should eq([0,9,0,0,0,0,0,0,0,0,0,0])}
      it 'updating a fee to afew months later will show up' do
        @timing9.update_attribute(:estimated_conclusion_fast, "Mon, 16 Feb 2015".to_date + 4.months)
        expect(Graph.fee_estimate_by_month(@user1,'estimated_conclusion_fast','low_estimate',0)).to eq([0,8,0,0,0,1,0,0,0,0,0,0])
      end

      it 'adding a new fee and timing  to an existing case will show the updated fee' do
        @timing12 = FactoryGirl.create(:timing, case_id: 21, estimated_conclusion_fast: "Mon, 16 Feb 2015".to_date + 4.months,
                                                        estimated_conclusion_expected: Date.today + 5.years,
                                                        estimated_conclusion_slow: Date.today + 6.years)
        @fee12 = FactoryGirl.create(:fee, case_id: 21, high_estimate: 60, medium_estimate: 60, low_estimate: 60)
        expect(Graph.fee_estimate_by_month(@user1,'estimated_conclusion_fast','high_estimate',0)).to eq([0,40,0,0,0,60,0,0,0,0,0,0])
      end
    end

    before { FactoryGirl.create(:overhead, lawfirm_id: 111, year: Date.today.year)}
    context 'expected overhead calculations' do
      subject { Graph.expected_overhead_next_year(@user1) }
      it { should eq(3000000) }
    end

    context 'expected overhead each month' do
      subject { Graph.overhead_by_month(@user1) }
      it { should eq(3000000/12)}
    end

    context 'Graph.open_cases_by_pg(user)' do
      subject { Graph.open_cases_by_pg(@user1) }
      it { should match_array([["test_group_1",3],["test_group_2",3],["test_group_3",3]]) }
    end

    context 'Graph.open_cases_by_pg_and_fee_estimate(user,fee_estimate)' do
      subject { Graph.open_cases_by_pg_and_fee_estimate(@user1,'low_estimate') }
      it { should match_array([['test_group_1',3],["test_group_2",3],["test_group_3",3]])}
    end

    context 'Graph.revenue_by_practice_group_estimated(user,fee_estimate,timing_estimate)' do
      subject { ActiveSupport::JSON.decode(Graph.revenue_by_practice_group_estimated(@user1,'low_estimate','estimated_conclusion_fast')) }
      it { should match_array([
                                {"name"=>"test_group_1", "data"=>[3,0,0,0,0]},
                                {"name"=>"test_group_2", "data"=>[3,0,0,0,0]},
                                {"name"=>"test_group_3", "data"=>[3,0,0,0,0]}
                              ])
          }
    end

  end
end
