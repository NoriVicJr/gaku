require 'spec_helper_models'

describe Gaku::ClassGroupCourseEnrollment do

  describe 'associations' do
    it { should belong_to :class_group }
    it { should belong_to :course }
  end

  describe 'validations' do
    it { should validate_presence_of :class_group_id }
    it { should validate_presence_of :course_id }
    it { should validate_uniqueness_of(:course_id).scoped_to(:class_group_id).with_message(/Already enrolled to the class group!/) }
  end

end
