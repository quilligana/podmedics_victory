class Question < ActiveRecord::Base

  belongs_to :video, counter_cache: true

  validates :stem, presence: true
  validates :answer_1, presence: true
  validates :answer_2, presence: true
  validates :correct_answer, presence: true
  validates :explanation, presence: true
  validates :video_id, presence: true
  validate :correct_answer_must_be_an_answer

  delegate :specialty_id, to: :video

  def correct_answer_must_be_an_answer
    if send("answer_#{correct_answer || 1}").nil?
      errors.add(:correct_answer, "is not a valid answer to the stem")
    end
  end

  def self.remaining_to_add
    (Video.count * 10) - self.count
  end

end
