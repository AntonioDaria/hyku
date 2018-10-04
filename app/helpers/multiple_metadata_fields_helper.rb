module MultipleMetadataFieldsHelper

  #called in app/views/hyrax/collection/_sort_and_per_page.html
  #sort_fields is 2 dimensional array
  def ubiquity_sort_field(sort_array)
    sort_array - [["relevance", "score desc, system_create_dtsi desc"], ["date modified ▼", "system_modified_dtsi desc"], ["date modified ▲", "system_modified_dtsi asc"]]
  end

  #takes in the creator value passed in from a solr document
  #It receives an array containing a single json string eg ['[{creator_family_name: mike}, {creator_given_name: hu}]']
  #We parse that json into an array of hashes as in [{creator_family_name: mike}, {creator_given_name: hu}]
  def display_json_values(json_data)
    if json_data.class == Array
      parsed_json = JSON.parse(json_data.first) if json_data.first.class == String
      data = []
      record = parsed_json.map do |hash|
        data << (hash["creator_given_name"].to_s + ' ' + hash["creator_family_name"].to_s)
        data << hash["creator_organization_name"]
        data
      end
      data.flatten.reject(&:blank?).compact
    end
  end

  def render_isni_or_orcid_url(id, type)
    new_id = id.delete(' ')
    uri = URI.parse(new_id)
    if (uri.scheme.present? &&  uri.host.present?)
      domain = uri
      domain.to_s
    elsif (uri.scheme.present? == false && uri.path.present?)
      split_path(uri, type)
    elsif (uri.scheme.present? == false && uri.host.present? == false)
      create_isni_and_orcid_url(new_id, type)
    end
  end

  #The uri looks like  `#<URI::Generic orcid.org/0000-0002-1825-0097>` hence the need to split_path;
  # `split_domain_from_path` returns `["orcid.org", "0000-0002-1825-0097"]`
  # get_type is subsctracting a sub array from the main array eg (["orcid", "org"] - ["org"]) and returns ["orcid"]
  def split_path(uri, type)
    split_domain_from_path = uri.path.split('/')
    if split_domain_from_path.length == 1
      id = split_domain_from_path.join('')
      create_isni_and_orcid_url(id, type)
    else
      get_host = split_domain_from_path.shift
      split_host = get_host.split('.')
      get_type = (split_host - ['org']).join('')
      get_id = split_domain_from_path.join('')
      create_isni_and_orcid_url(get_id, get_type)
    end
  end

  def create_isni_and_orcid_url(id, type)
    if type == 'orcid'
      host = URI('https://orcid.org/')
      host.path = "/#{id}"
      host.to_s
    elsif type == "isni"
      host = URI('http://www.isni.org')
      host.path = "/isni/#{id}"
      host.to_s
    end
  end

  #Here we are checking in the works and search result page if the hash_keys for json fields
  # include values for either isni or orcid before displaying parenthesis
  def display_paren?(hash_keys, valid_keys)
    (hash_keys & valid_keys).any?
  end

  #Here we are checking in the works and search result page if the hash_keys for json fields
  # include a subset that is an array that includes either isni or orcid alongside contributor type before displaying a comma
  def display_comma?(hash_keys, valid_keys)
    all_keys_set = hash_keys.to_set
    if valid_keys == ["contributor_type", "contributor_orcid", "contributor_isni"]
      keys_with_orcid_id = valid_keys.take(2)
      keys_with_isni_id = [valid_keys.first, valid_keys.last]
      array_with_orcid_id_set = keys_with_orcid_id.to_set
      array_with_isni_id_set = keys_with_isni_id.to_set
      array_with_orcid_id_set.subset? all_keys_set or array_with_isni_id_set.subset? all_keys_set
    else
      needed_keys_set = valid_keys.to_set
      needed_keys_set.subset? all_keys_set
    end
  end

  def get_model(model_class, model_id, field, multipart_sort_field_name = nil)
    model ||= fetch_model(model_class, model_id)
    record ||= model.send(field.to_sym)
    get_json_data = record.first if !record.empty?
    value =   get_json_data || model

    # if passed in field = contributor and it is nil, return getch model using creator
    # return empty string if passed in field has value in database ie (value == nil)
    return ""  if (value == nil)

    if valid_json?(value)
      # when an creator is an array witha json string
      # same as  JSON.parse(model.creator.first)
      array_of_hash ||= JSON.parse(model.send(field.to_sym).first)
      return sort_hash(array_of_hash, multipart_sort_field_name) if multipart_sort_field_name
      array_of_hash
    else
      # returned when field is not a json. Return array to avoiding returning ActiveTriples::Relation
      record || [value.attributes]
    end
  end

  private

  # return false if json == String
  def valid_json?(data)
    # return if json == nil
    !!JSON.parse(data)  if data.class == String
    rescue JSON::ParserError
      false
  end

  def fetch_model(model_class, model_id)
    # from edit page the model class is a constant but from show page it is a string
    if model_class.class == String
      (model_class.constantize).find(model_id)
    else
      model_class.find(model_id)
    end
  end

  def sort_hash(array_of_hash, key)
    return array_of_hash if array_of_hash.class != Array
    if key.present?
      array_of_hash.sort_by!{ |hash| hash[key].to_i}
      array_of_hash.map {|hash| hash.reject { |k,v| v.nil? || v.to_s.empty? ||v == "NaN" }}
    end
  end
end
