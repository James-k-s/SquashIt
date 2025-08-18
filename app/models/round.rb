class Round < ApplicationRecord
  belongs_to :match
  belongs_to :winner, class_name: 'User', optional: true

end
