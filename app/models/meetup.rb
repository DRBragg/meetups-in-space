class Meetup < ActiveRecord::Base
  has_many :rsvps
  has_many :users, :through => :rsvps

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :creator_id, presence: true

  def creator
    creator = User.find(self.creator_id)
    return creator.username
  end
end
