# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.
  use_extension(Hydra::ContentNegotiation)

  attribute :extent, Solr::Array, solr_name('extent')
  attribute :rendering_ids, Solr::Array, solr_name('hasFormat', :symbol)
  attribute :isni, Solr::Array, solr_name('isni')
  attribute :institution, Solr::Array, solr_name('institution')
  attribute :org_unit, Solr::Array, solr_name('org_unit')
  attribute :refereed, Solr::Array, solr_name('refereed')
  attribute :funder, Solr::Array, solr_name('funder')
  attribute :fndr_project_ref, Solr::Array, solr_name('fndr_project_ref')
  attribute :add_info, Solr::Array, solr_name('add_info')
  attribute :date_published, Solr::Array, solr_name('date_published')
  attribute :date_accepted, Solr::Array, solr_name('date_accepted')
  attribute :date_submitted, Solr::Array, solr_name('date_submitted')
  attribute :journal_title, Solr::Array, solr_name('journal_title')
  attribute :issue, Solr::Array, solr_name('issue')
  attribute :volume, Solr::Array, solr_name('volume')
  attribute :pagination, Solr::Array, solr_name('pagination')
  attribute :article_num, Solr::Array, solr_name('article_num')
  attribute :project_name, Solr::Array, solr_name('project_name')
  attribute :rights_holder, Solr::Array, solr_name('rights_holder')
  attribute :doi, Solr::Array, solr_name('doi')
  attribute :issn, Solr::Array, solr_name('issn')
  attribute :eissn, Solr::Array, solr_name('eissn')
  attribute :official_link, Solr::Array, solr_name('official_link')

  attribute :creator_name_type, Solr::Array, solr_name('creator_name_type')
  attribute :given_name, Solr::Array, solr_name('given_name')
  attribute :family_name, Solr::Array, solr_name('family_name')
  attribute :orcid, Solr::Array, solr_name('orcid')
  #attribute :isni, Solr::Array, solr_name('isni')
  attribute :creator_organization, Solr::Array, solr_name('creator_organization')

  attribute :contributor_type, Solr::Array, solr_name('contributor_type')
  attribute :contributor_given_name, Solr::Array, solr_name('contributor_given_name')
  attribute :contributor_family_name, Solr::Array, solr_name('contributor_family_name')
  attribute :contributor_orcid, Solr::Array, solr_name('contributor_orcid')
  attribute :contributor_isni, Solr::Array, solr_name('contributor_isni')
  attribute :contributor_organization, Solr::Array, solr_name('contributor_organization')


end
