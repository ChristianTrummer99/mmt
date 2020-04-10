# the order of these match the CMR docs
@validGranuleQueryParameters = [
  # 'collection_concept_id', we don't want this to be allowed in the query
  'granule_ur',
  'producer_granule_id',
  'readable_granule_name',
  'online_only',
  'downloadable',
  'attribute',
  'polygon',
  'bounding_box',
  'point',
  'line',
  # we are not providing a shapefile upload option at this time
  'orbit_number',
  'equator_crossing_longitude',
  'equator_crossing_date',
  'updated_since',
  'revision_date',
  'production_date',
  'cloud_cover',
  'platform',
  'instrument',
  'sensor',
  'project',
  'campaign', # alias for project
  'concept_id', # can be used for collections too...
  'echo_granule_id',
  'echo_collection_id',
  'day_night_flag',
  'day_night', # for unspecified, in the docs
  'two_d_coordinate_system',
  'provider',
  'native_id',
  'short_name',
  'entry_title',
  'temporal',
  'cycle',
  'passes',
  'exclude',
  'options'
  # not including sort_key
]


$(document).ready ->
  if $('.subscription-form').length > 0

    # Validate email subscription form
    $('.subscription-form').validate
      rules:
        'subscription[Name]':
          required: true
        'subscription[CollectionConceptId]':
          required: true
        'subscription[Query]':
          required: true
          isValidQuery: true
        'subscription[SubscriberId]':
          required: true
      messages:
        'subscription[Name]':
          required: 'Subscription Name is required.'
        'subscription[CollectionConceptId]':
          required: 'Collection Concept ID is required.'
        'subscription[Query]':
          required: 'Query is required.'
          isValidQuery: 'Query must be a valid CMR granule search query.'
        'subscription[SubscriberId]':
          required: 'Subscriber is required.'

      errorPlacement: (error, element) ->
        if element.attr('id') == 'subscriber'
          element.closest('.subscriber-group').append(error)
        else
          error.insertAfter(element)


    # method for validating query
    $.validator.addMethod 'isValidQuery', (value, elem, params) ->
      query = value
      queryRgx = /^\??(([\[\]\\\w]+)=[\\\.\-\:\,\%\+\*\w]+&?)+$/

      return false if queryRgx.test(query) == false

      parts = query.split('&')

      for part in parts
        # remove the beginning ? if it was provided
        # some parameters can have brackets or escapes before the brackets. we are only checking what is before the bracket
        parameter = part.replace(/^\?/, '').split('=')[0].split('[')[0].split('\\')[0]

        # is the parameter listed in the CMR docs?
        return false if validGranuleQueryParameters.indexOf(parameter) == -1

      true
