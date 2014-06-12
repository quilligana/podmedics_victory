module UnsubscribeMacros

  def checkbox_check(check_box_name)
    describe "#{check_box_name} checkbox" do
      it 'exists' do
        find(:checkbox, "unsub_#{check_box_name}")
      end

      it 'is unchecked by default' do
        expect(has_checked_field?(check_box_name)).to be_false
      end
    end
  end 

  def unsubscribe_check(email_type_to_unsubscribe)
    describe "with #{email_type_to_unsubscribe} checked" do
      before do
        check("unsub_#{email_type_to_unsubscribe}")
        click_button 'Unsubscribe'
        @user.reload
      end

      it "unsubscribes the user from #{email_type_to_unsubscribe}" do
        expect(@user[email_type_to_unsubscribe]).to eq false
      end

      it 'leaves the other boxes subscribed' do
        EMAIL_TYPES.each do |email_type|
          unless email_type == email_type_to_unsubscribe
            expect(@user[email_type]).to eq true
          end
        end
      end
    end
  end

end
