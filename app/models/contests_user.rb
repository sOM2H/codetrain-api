class ContestsUser < ApplicationRecord
  belongs_to :contest
  belongs_to :user
end
