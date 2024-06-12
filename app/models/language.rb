class Language < ApplicationRecord
  has_many :attempts, dependent: :destroy
end
