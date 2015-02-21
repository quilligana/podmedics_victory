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
#

require 'spec_helper'

describe Flashcard do
end
