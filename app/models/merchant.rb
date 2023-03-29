class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.name_search(query_name)
    Merchant.where("lower(name) LIKE lower('%#{query_name}%')").order(:name).first
  end
end

