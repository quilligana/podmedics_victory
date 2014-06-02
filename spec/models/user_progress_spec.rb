require 'spec_helper'

describe UserProgress do

  before :each do
    @user = create(:user)
    @specialty = create(:specialty)
    @video = create(:video, specialty: @specialty)
    @question = create(:question, video: @video)
    @question_2 = create(:question, video: @video)
    @specialty_question = create(:specialty_question, specialty_id: @specialty.id)
    @progress_instance = UserProgress.new(@specialty, @user)
  end

  it 'should be instantiated with a specialty and a user arguement' do
      expect { UserProgress.new(@specialty, @user) }.not_to raise_error
      expect { UserProgress.new }.to raise_error
  end

  describe '#max_specialty_points' do
    it 'should return the maximum number of points available' do
      @progress_instance.max_specialty_points.should eq 60
    end
  end

  describe '#user_specialty_points' do
    it 'should return the users points in that specialty' do
      @progress_instance.user_specialty_points.should eq 0
    end

    it 'should return the users updated points in that specialty' do
      create(:user_question, user_id: @user.id, question_id: @question.id, correct_answer: true)
      create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true)
      comment = create(:comment, user_id: @user.id, commentable_type: "SpecialtyQuestion", commentable_id: @specialty_question.id, accepted: true)
      create(:vote, comment_id: comment.id)
      @progress_instance.user_specialty_points.should eq 66
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
      create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true)
      create(:user_question, user_id: @user.id, question_id: @question_2.id, correct_answer: true)
      @progress_instance.next_badge.should eq "Registrar"
    end
  end

  describe '#next_badge_points' do
    it 'should return the users next badge in the specialty' do
      @progress_instance.next_badge_points.should eq 21
      create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true)
      @progress_instance.next_badge_points.should eq 36
    end
  end

  describe "#professor_points" do
    context 'if no professor exists in the specialty' do
      it 'should return the max specialty points' do
        @progress_instance.professor_points.should eq 60
      end
    end
    context "if a professor exists" do
      before do
        @user_2 = create(:user)
        create(:user_question, user_id: @user_2.id, question_id: @question.id, correct_answer: true)
        @specialty.professor = @user_2.id
      end
      it "should return the current professor's specialty points +1" do
        @progress_instance.professor_points.should eq 11
      end
    end
  end

  describe "#due_badge?" do
    context 'if the current user does not yet have a badge' do

      it 'should return false if the user has not made grade_level 0' do
        @progress_instance.due_badge?.should eq false
      end

      it 'should return true if the user has made grade_level 0' do
        create(:user_question, user_id: @user.id, question_id: @question.id, correct_answer: true)
        create(:user_question, user_id: @user.id, question_id: @question_2.id, correct_answer: true)
        create(:comment, user_id: @user.id, commentable_type: "SpecialtyQuestion", commentable_id: @specialty_question.id)
        @progress_instance.due_badge?.should eq true
      end
    end

    context "if the current user already has badges" do

      before do
        create(:user_question, user_id: @user.id, question_id: @question.id, correct_answer: true)
        create(:user_question, user_id: @user.id, question_id: @question_2.id, correct_answer: true)
        create(:comment, user_id: @user.id, commentable_type: "SpecialtyQuestion", commentable_id: @specialty_question.id)
        create(:badge, user_id: @user.id, specialty_id: @specialty.id)
      end

      it 'should return false if the user has not changed grade_level' do
        @progress_instance.due_badge?.should eq false
      end

      it "should return true if the user has changed grade_level" do
        create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true)
        @progress_instance.due_badge?.should eq true
      end

    end
  end

  describe '#award_badge' do

    it "should not award a badge if its not deserved" do
        expect do
          @progress_instance.award_badge
        end.not_to change { Badge.count }
    end

    before do
      create(:user_question, user_id: @user.id, question_id: @question.id, correct_answer: true)
      create(:user_question, user_id: @user.id, question_id: @question_2.id, correct_answer: true)
    end

    context 'no previous badges in specialty' do
      it 'should award a badge when a user reaches grade level zero' do
        create(:comment, user_id: @user.id, commentable_type: "SpecialtyQuestion", commentable_id: @specialty_question.id)
        expect do
          @progress_instance.award_badge
        end.to change { Badge.count }
      end
    end

    context 'with previous badges in specialty' do
      it 'should award a badge when a user reaches the grade level' do
        create(:comment, user_id: @user.id, commentable_type: "SpecialtyQuestion", commentable_id: @specialty_question.id)
        create(:badge, user_id: @user.id, specialty_id: @specialty.id)
        create(:vimeo, user_id: @user.id, video_id: @video.id, completed: true)
        expect do
          @progress_instance.award_badge
        end.to change { Badge.count }
      end
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