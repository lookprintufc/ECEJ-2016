class Event < ActiveRecord::Base
  validates :name,
            presence: true
  validates :facilitator,
            presence: true
  validates :limit,
            presence: true
  validates :start,
            presence: true
  validates :end,
            presence: true
  validate :start_must_be_smaller_than_end

  has_many :subscriptions
  has_many :users, through: :subscriptions

  # Returns all past events
  def self.past
    Event.select { |event| DateTime.now > event.end }
  end

  # Returns all future events
  def self.future
    Event.select { |event| DateTime.now < event.start}
  end

  # Returns all events tha are happening at the moment
  def self.happening
    now = DateTime.now
    Event.select { |event| now < event.end && now > event.start }
  end

  # Return the all dates that have, at least, one event with no duplicates and ordered
  def self.days
    days = []
    Event.all.each do |event|
      date = event.start.to_date
      days << date unless days.include?(date)
    end
    days.sort
  end

  # Add a user to the event
  def add(user)
    users << user
  end

  # Remove the user from the event
  def remove(user)
    users.delete user
  end

  # Checks if the event is full
  def full?
    users.count > limit
  end

  # Checks if the events is happening at the moment
  def is_happening_now?
    now = DateTime.now
    now > self.start && now < self.end
  end

  # Validator method
  def start_must_be_smaller_than_end
    errors.add(:start, "deve ser menor que a data de término") if self.start > self.end
  end
end
