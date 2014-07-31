# == Schema Information
#
# Table name: newsletters
#
#  id           :integer          not null, primary key
#  subject      :string(255)
#  body_content :text
#  body_text    :text
#  sent_at      :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Newsletter do

  it { should validate_presence_of :subject}
  it { should validate_presence_of :body_content }
  it { should validate_presence_of :body_text }

end
