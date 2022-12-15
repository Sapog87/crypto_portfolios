class Deal < ApplicationRecord
  belongs_to :portfolio
  belongs_to :currency
end
