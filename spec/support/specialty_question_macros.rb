module SpecialtyQuestionMacros

	def submit_question
		click_link "Ask a Question"
		fill_in "specialty_question_content", with: @question_text
		click_button "Create Specialty question"
	end

end
