module SpecialtyQuestionMacros

	def submit_question
    click_link "Ask the Podmedics Community a question"
		fill_in "specialty_question_content", with: @question_text
		click_button "Create Specialty question"
	end

end
