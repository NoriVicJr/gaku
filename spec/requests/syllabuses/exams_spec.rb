require 'spec_helper'

describe 'Syllabus Exams' do
  stub_authorization!

  before do
    @syllabus = Factory(:syllabus, :name => 'Biology', :code => 'bio')
    visit syllabuses_path
  end

  context "add and show exams" do
    before do 
      within('table.index tr:nth-child(2)') { click_link "show" }
      page.should have_content("No Exams")
      click_link 'add_syllabus_exam_link'
      wait_until { find('#new_syllabus_exam_form').visible? }
    end

    it "should add and show exams", :js => true  do
      @syllabus.exams.count.should eql(0)
      #required
      fill_in 'exam_name', :with => 'Biology Exam'
      fill_in 'exam_exam_portions_attributes_0_name' , :with => 'Biology Exam Portion'
      click_button 'submit_button'

      wait_until { !page.find('#new_syllabus_exam_form').visible? }
      page.should have_content('Biology Exam')
      page.should_not have_content("No Exams")
      @syllabus.exams.count.should eql(1)
    end

    it 'should error if the required fields are empty', :js => true do 
      fill_in 'exam_exam_portions_attributes_0_name', :with => ''
      click_button 'submit_button'

      wait_until do 
        page.should have_selector('div.exam_nameformError') 
        page.should have_selector('div.exam_exam_portions_attributes_0_nameformError') 
      end

      @syllabus.exams.count.should eql(0)
    end 
  end

  context 'show, edit, delete' do 

    before do 
      @exam = Factory(:exam, :name => 'Astronomy Exam')
      @syllabus.exams << @exam
      visit syllabus_path(@syllabus)
    end

    it 'should edit exam' do 
      click_link 'edit_link'
      current_url.should == edit_exam_url(:id => @exam.id)
      fill_in 'exam_name', :with => 'Ruby Exam'
      click_button 'submit_button'

      page.should have_content('Ruby Exam')
      current_url.should == exam_url(:id => @exam.id)
    end

    it 'should show exam'  do 
      click_link 'show_link'
      page.should have_content('Show Exam')
      page.should have_content('Exam portions list')
      page.should have_content('Astronomy Exam')
      current_url.should == exam_url(:id => @exam.id)
    end

    it 'should delete a syllabus exam', :js => true do
      @syllabus.exams.size.should eql(1)
      tr_count = page.all('table.index tr').size
      page.should have_content(@exam.name)

      click_link "delete_link" 
      page.driver.browser.switch_to.alert.accept
      
      wait_until { page.all('table.index tr').size == tr_count - 1 }
      @syllabus.exams.reload 
      page.should_not have_content(@exam.name)
      @syllabus.exams.size.should eql(0) 
    end
  end
  
end