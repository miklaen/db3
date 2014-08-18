class Splatt < ActiveRecord::Base
  belongs_to :user

  validates :body, presence: true
  validates :belongs_to, presence: true
end
