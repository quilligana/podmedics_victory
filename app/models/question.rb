class Question < ActiveRecord::Base

  belongs_to :video, counter_cache: true

  validates :stem, :presence => true
  validates :answer_1, :presence => true
  validates :answer_2, :presence => true
  validates :correct_answer, presence: true
  validate :correct_answer_must_be_an_answer
  validates :explanation, :presence => true
  validates :video_id, :presence => true

  delegate :specialty_id, to: :video

  def correct_answer_must_be_an_answer
    if send("answer_#{correct_answer || 1}").nil?
      errors.add(:correct_answer, "is not a valid answer")
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      question = Question.new
      parameters = ActionController::Parameters.new(row.to_hash)
      question.update(parameters.permit(:stem, :answer_1, :answer_2, :answer_3, :answer_4, :answer_5, :explanation, :correct_answer, :video_id))
      question.save!
    end
  end

end
