class DraftRelationValuePost < ApplicationRecord
  belongs_to :relation_value
  belongs_to :post
end
