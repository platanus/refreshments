class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def first_error_per_attr
    errors.details.keys.map { |attribute| errors.full_messages_for(attribute).first }
  end
end
