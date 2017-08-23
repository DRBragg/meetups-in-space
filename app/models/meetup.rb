class Meetup < ActiveRecord::Base
  def creator
    creator = User.find(self.creator_id)
    return creator.username
  end
end
