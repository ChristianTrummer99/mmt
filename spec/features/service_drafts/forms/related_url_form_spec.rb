require 'rails_helper'
require 'features/service_drafts/lib/forms/options_form_spec'

describe 'Related URL Form', js: true do
  before do
    login
    draft = create(:empty_service_draft, user: User.where(urs_uid: 'testuser').first)
    visit edit_service_draft_path(draft, 'related_url')
  end

  context 'when submitting the form' do
    before do
      fill_in 'Description', with: 'Test related url'
      select 'Distribution URL', from: 'Url Content Type'
      select 'Get Service', from: 'Type'
      select 'Software Package', from: 'Subtype'
      fill_in 'Url', with: 'nasa.gov'
      select 'application/json', from: 'Mime Type'
      select 'HTTP', from: 'Protocol'
      fill_in 'Full Name', with: 'Test Service'
      fill_in 'Data ID', with: 'Test data'
      fill_in 'Data Type', with: 'Test data type'
      fill_in 'service_draft_draft_related_url_get_service_uri_0', with: 'Test URI 1'
      click_on 'Add another Uri'
      fill_in 'service_draft_draft_related_url_get_service_uri_1', with: 'Test URI 2'

      within '.nav-top' do
        click_on 'Save'
      end

      # TODO validation isn't working correctly
      click_on 'Yes'
    end

    it 'displays a confirmation message' do
      expect(page).to have_content('Service Draft Updated Successfully!')
    end

    context 'when viewing the form' do
      include_examples 'Related URL Form'
    end
  end
end