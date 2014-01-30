require 'spec_helper'

describe "user_details/new" do
  before(:each) do
    assign(:user_detail, stub_model(UserDetail,
      :forename => "MyString",
      :surname => "MyString",
      :gender => "MyString",
      :location => "MyString"
    ).as_new_record)
  end

  it "renders new user_detail form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_details_path, "post" do
      assert_select "input#user_detail_forename[name=?]", "user_detail[forename]"
      assert_select "input#user_detail_surname[name=?]", "user_detail[surname]"
      assert_select "input#user_detail_gender[name=?]", "user_detail[gender]"
      assert_select "input#user_detail_location[name=?]", "user_detail[location]"
    end
  end
end
