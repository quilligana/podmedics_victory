# == Schema Information
#
# Table name: flashcards
#
#  id             :integer          not null, primary key
#  specialty_id   :integer
#  video_id       :integer
#  views          :integer          default(0)
#  title          :string(255)
#  epidemiology   :text
#  pathology      :text
#  causes         :text
#  signs          :text
#  symptoms       :text
#  inv_cultures   :text
#  inv_bloods     :text
#  inv_imaging    :text
#  inv_scopic     :text
#  inv_functional :text
#  treat_cons     :text
#  treat_medical  :text
#  treat_surgical :text
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#

class Flashcard < ActiveRecord::Base

  belongs_to :video
  belongs_to :specialty
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :specialty_id
  validates_presence_of :user_id
  validates_presence_of :epidemiology
  validates_presence_of :pathology
  validates_presence_of :causes
  validates_presence_of :signs
  validates_presence_of :symptoms
  validates_presence_of :inv_cultures
  validates_presence_of :inv_bloods
  validates_presence_of :inv_imaging
  validates_presence_of :inv_scopic
  validates_presence_of :inv_functional
  validates_presence_of :treat_cons
  validates_presence_of :treat_medical
  validates_presence_of :treat_surgical

  def has_video?
    true if video
  end

end
