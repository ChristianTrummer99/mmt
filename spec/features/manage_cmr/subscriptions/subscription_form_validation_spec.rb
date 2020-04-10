describe 'Subscription Form Validation', js: true do
  before do
    login
  end

  context 'when subscriptions is turned on' do
    let(:name) { 'Name for Subscription Testing the Form' }
    let(:collection_concept_id) { 'C1234-MMT_2' }

    before do
      allow_any_instance_of(SubscriptionPolicy).to receive(:create?).and_return(true)
    end

    context 'when visiting the new subscription form' do
      before do
        visit new_subscription_path
      end

      it 'displays the new subscription form' do
        expect(page).to have_content('New MMT_2 Subscription')

        expect(page).to have_field('Subscription Name', type: 'text')
        expect(page).to have_field('Collection Concept ID', type: 'text')
        expect(page).to have_content('Enter a Concept ID for a single collection. (Example: C1234567-PODAAC)')
        expect(page).to have_field('Query', type: 'textarea')
        expect(page).to have_content('Enter the CMR query parameters for the subscription. (Examples: Platform[]=1B&platform[]=2B, or bounding_box=-10,-5,10,5, or attribute[]=float,PERCENTAGE,25.5,30) Note: Do not include the Collection Concept ID in the query as it has already been specified in the field above.')
        expect(page).to have_field('Subscriber', type: 'select')
      end

      context 'when submitting an invalid empty subscription form' do
        before do
          within '.subscription-form' do
            click_on 'Submit'
          end
        end

        it 'displays validation errors within the form' do
          expect(page).to have_content('Subscription Name is required.')
          expect(page).to have_content('Collection Concept ID is required.')
          expect(page).to have_content('Query is required.')
          expect(page).to have_content('Subscriber is required.')
        end
      end

      context 'when submitting a subscription query with an invalid structure' do
        let(:invalid_query_structure) { 'thisisabadquery123456$#*(@notlookingforanything' }

        before do
          fill_in 'Query', with: invalid_query_structure
          fill_in 'Name', with: name
          fill_in 'Collection Concept ID', with: collection_concept_id

          within '.subscription-form' do
            click_on 'Submit'
          end
        end

        it 'displays the proper validation errors withing the form' do
          expect(page).to have_content('Query must be a valid CMR granule search query.')
          expect(page).to have_content('Subscriber is required.')

          expect(page).to have_no_content('Subscription Name is required.')
          expect(page).to have_no_content('Collection Concept ID is required.')
        end
      end

      context 'when submitting a subscription query with invalid parameter(s)' do
        let(:invalid_query_params) { '?something=something&random_param[]=zyxw' }

        before do
          fill_in 'Query', with: invalid_query_params
          fill_in 'Name', with: name
          fill_in 'Collection Concept ID', with: collection_concept_id

          within '.subscription-form' do
            click_on 'Submit'
          end
        end

        it 'displays the proper validation errors withing the form' do
          expect(page).to have_content('Query must be a valid CMR granule search query.')
          expect(page).to have_content('Subscriber is required.')

          expect(page).to have_no_content('Subscription Name is required.')
          expect(page).to have_no_content('Collection Concept ID is required.')
        end
      end

      context 'when submitting a subscription query that contains the collection concept id parameter' do
        let(:invalid_query_with_collection_concept_id) { '?collection_concept_id=C1234-MMT_2&point=100,20&downloadable=true&day_night_flag=night' }

        before do
          fill_in 'Query', with: invalid_query_with_collection_concept_id
          fill_in 'Name', with: name
          fill_in 'Collection Concept ID', with: collection_concept_id

          within '.subscription-form' do
            click_on 'Submit'
          end
        end

        it 'displays the proper validation errors withing the form' do
          expect(page).to have_content('Query must be a valid CMR granule search query.')
          expect(page).to have_content('Subscriber is required.')

          expect(page).to have_no_content('Subscription Name is required.')
          expect(page).to have_no_content('Collection Concept ID is required.')
        end
      end
    end
  end
end
