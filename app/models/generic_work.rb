class GenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include HasRendering

  include Ubiquity::BasicMetadataDecorator
  include Ubiquity::AllModelsVirtualFields
  
  validates :title, presence: { message: 'Your work must have a title.' }

  # This indexer uses IIIF thumbnails:
  self.indexer = WorkIndexer
  self.human_readable_type = 'Work'
end
