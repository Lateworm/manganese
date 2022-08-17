class Album < ApplicationRecord
  belongs_to :artist
  has_many :recommendations
  has_many :sources
  has_many :plays
end
