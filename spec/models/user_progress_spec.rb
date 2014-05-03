require 'spec_helper'

describe UserProgress do

  before :each do
    @user = create(:user)
    @specialty = create(:specialty)
    @video = create(:video, specialty: @specialty)
    @question = create(:question, video: @video)
    @question_2 = create(:question, video: @video)
    @progress_instance = UserProgress.new(@specialty, @user)
  end

  it 'should be instantiated with a specialty and a user arguement' do
      expect { UserProgress.new(@specialty, @user) }.not_to raise_error
      expect { UserProgress.new }.to raise_error
  end

  describe '#max_specialty_points' do
    it 'should return the maximum number of points available' do
      @progress_instance.max_specialty_points.should eq 15
    end
  end

  describe '#user_specialty_points' do
    it 'should return the users points in that specialty' do
      @progress_instance.user_specialty_points.should eq 0
    end

    it 'should return the users updated points in that specialty' do
      create(:user_question, user_id: @user.id, question_id: @question.id, correct_answer: true)
      create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true)
      @progress_instance.user_specialty_points.should eq 10
    end
  end

  describe '#current_badge' do
    it 'should return the users highest badge in the specialty' do
      @progress_instance.current_badge.should eq nil
      @user.badges.create(specialty_id: @specialty.id, level: "Medical Student")
      @progress_instance.current_badge.level.should eq "Medical Student"
    end
  end

  describe '#next_badge' do
    it 'should return the users next badge in the specialty' do
      @progress_instance.next_badge.should eq "Medical Student"
      UserQuestion.create(user_id: @user.id, question_id: @question.id, correct_answer: true)
      UserQuestion.create(user_id: @user.id, question_id: @question_2.id, correct_answer: true)
      @progress_instance.next_badge.should eq "Consultant"
    end
  end

  describe '#next_badge_points' do
    it 'should return the users next badge in the specialty' do
      @progress_instance.next_badge_points.should eq 5
      UserQuestion.create(user_id: @user.id, question_id: @question.id, correct_answer: true)
      @progress_instance.next_badge_points.should eq 7
    end
  end

  describe '#award_badge' do
    it 'should award a badge when a user reaches the grade level' do
      @progress_instance.award_badge.should eq nil
      UserQuestion.create(user_id: @user.id, question_id: @question.id, correct_answer: true)
      expect do
        @progress_instance.award_badge
      end.to change { Badge.count }
    end
  end

  describe '#check_professor_badge' do
    before do
      @user_2 = create(:user)
      @specialty.professor = @user_2.id
      create(:badge, user_id: @user_2.id, specialty_id: @specialty.id, level: "Professor")
    end

    context 'when a user surpasses the professor' do
      before { create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true) }

      it 'should change the professor' do
        @progress_instance.check_professor_badge
        expect(@user_2.badges.count).to be(0)
        expect(@user.badges.count).to be(1)
        expect(@specialty.professor).to be(@user.id)
      end

    end

    context 'when a user doesnt surpass the professor' do

      it 'should not change the professor' do
        @progress_instance.check_professor_badge
        expect(@user_2.badges.count).to be(1)
        expect(@user.badges.count).to be(0)
        expect(@specialty.professor).to be(@user_2.id)
      end

    end
  end

  describe '#award_professor_badge' do
    it 'should award the professor badge and update the professor of the specialty' do
      expect(Badge.count).to be(0)
      expect(@specialty.professor).to be(nil)
      @progress_instance.award_professor_badge

      expect(Badge.count).to be(1)
      expect(@specialty.professor).to be(@user.id)
    end
  end
end