# Generated via
#  `rails generate hyrax:work Report`
module Hyrax
  class ReportForm < Hyrax::Forms::WorkForm
    include Hyrax::FormTerms
    self.model_class = ::Report
    self.terms += [:resource_type]
  end
end
