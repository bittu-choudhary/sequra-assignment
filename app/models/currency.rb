class Currency < ApplicationRecord
    has_many :merchants

    validates :name, uniqueness: true, presence: true
    validates :code, uniqueness: true, presence: true

end
