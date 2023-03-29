class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items, dependent: :delete_all
  has_many :items, through: :invoice_items
  belongs_to :merchant
end