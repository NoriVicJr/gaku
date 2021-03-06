require 'spec_helper'

describe 'Admin School Picture' do

  let(:school) { create(:school) }
  let(:school_with_picture) { create(:school, picture: uploaded_file('120x120.jpg')) }

  before { as :admin }

  context 'without picture' do
    before do
      visit gaku.edit_admin_school_path(school)
    end

    it 'upload avatar', js: true do
      click '#avatar-picture'
      expect do
        attach_file :school_picture, File.join(Rails.root + '../support/120x120.jpg')
        click_button 'Upload'
        wait_for_ajax
        school.reload
        flash_updated?
      end.to change(school, :picture_content_type).from(nil).to('image/jpeg')
    end
  end

  context 'with picture' do
    before do
      visit gaku.edit_admin_school_path(school_with_picture)
    end

    context 'show avatar' do
      it_behaves_like 'show avatar'
    end

    it 'remove avatar', js: true do
      click '#avatar-picture'
      click '.remove-picture-link'
      accept_alert
      wait_for_ajax
      flash_destroyed?
      school_with_picture.reload
      expect(school_with_picture.picture).to_not be_file
    end
  end
end
