module Helpers
  module GroupHelper
    def create_group(provider_id: 'MMT_2', name: random_group_name, description: random_group_description, members: [], admin: false)
      ActiveSupport::Notifications.instrument 'mmt.performance', activity: 'Helpers::GroupHelper#create_group' do
        group_params = {
          'name'        => name,
          'description' => description
        }
        # System level groups don't have a provider_id
        group_params['provider_id'] = provider_id unless provider_id.nil?

        # If members were provided, include them in the payload
        group_params['members'] = members if members.any?
        
        group_response = cmr_client.create_group(group_params, admin ? 'access_token_admin' : 'access_token')

        raise Array.wrap(group_response.body['errors']).join(' /// ') if group_response.body.key?('errors')

        wait_for_cmr

        return group_response.body
      end
    end

    def delete_group(concept_id:, admin: false)
      ActiveSupport::Notifications.instrument 'mmt.performance', activity: 'Helpers::GroupHelper#delete_group' do
        cmr_client.delete_group(concept_id, admin ? 'access_token_admin' : 'access_token')

        wait_for_cmr
      end
    end

    def random_group_name
      # Using multiple categorie helps ensure randomized results if multiple
      # requests come in quickly
      category = %w(galaxy moon star star_cluster).sample

      Faker::Space.send(category)
    end

    def random_group_description
      Faker::Lorem.sentence
    end

    def group_concept_from_path
      current_path.sub('/groups/', '')
    end
  end
end
