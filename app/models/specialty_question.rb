class SpecialtyQuestion < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :specialty

  has_many :answers, as: :commentable, class_name: 'Comment', dependent: :destroy
  has_many :nested_answers, as: :root, class_name: 'Comment'

  validates :content, presence: true
  validates :user, presence: true
  validates :specialty, presence: true

  # Answers

  def get_answers(include_hidden = false)
    include_hidden ? self.answers.sort_by(&:score).reverse : self.answers.available.sort_by(&:score).reverse
  end
  
  def cached_answers(include_hidden = false)
    Rails.cache.fetch([self, "comments"]) { get_answers(include_hidden).to_a }
  end


  # Answers count
  
  def answers_count(include_hidden = false)
    include_hidden ? self.nested_answers.size : self.nested_answers.available.size
  end

  def cached_answers_count(include_hidden = false)
    Rails.cache.fetch([self, "comments_count"]) { answers_count(include_hidden) }
  end
  

  # Accepted Answer functions

  def accept_answer(answer, user)
    if !already_accepted_answer? && self.user == user && answer.acceptable?
      answer.accept
    end
  end

  def accepted_answer
    nested_answers.find_by(accepted: true)
  end

  def already_accepted_answer?
    nested_answers.where(accepted: true).size > 0 ? true : false
  end

end
