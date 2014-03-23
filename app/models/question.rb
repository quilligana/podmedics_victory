class Question < ActiveRecord::Base

  belongs_to :video

  validates :stem, :presence => true
  validates :answer_1, :presence => true
  validates :answer_2, :presence => true
  validates :answer_3, :presence => true
  validates :answer_4, :presence => true
  validates :answer_5, :presence => true
  validates :correct_answer, :presence => true
  validates :explanation, :presence => true
  validates :video_id, :presence => true

  delegate :specialty_id, to: :video
end
