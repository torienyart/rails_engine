class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates :unit_price, numericality: { only_float: true }

  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  def destroy_invoices
    invoices_to_destroy = Invoice.joins(:items).group("invoices.id").having("count(items.id) = 1")
    invoices_to_destroy.each do |invoice|
      invoice.destroy
    end
  end

  def self.name_search(query_name)
    where("lower(name) LIKE lower('%#{query_name}%')").order(:name)
  end

  def self.price_search(min, max)
    if min.present? && max.present?
      where("unit_price >= #{min}").where("unit_price <= #{max}").order(:unit_price)
    elsif min.present? && !max.present?
      where("unit_price >= #{min}").order(:unit_price)
    elsif max.present? && !min.present?
      where("unit_price <= #{max}").order(:unit_price)
    end
  end
end