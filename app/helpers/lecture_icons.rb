class LectureIcons

  def initialize(video, current_user, template)
    @template = template
    @video = video
    @current_user = current_user
  end

  def show_lecture_icons
    (lecture_watched + not_watched + part_watched + poor_score +
    resit_lecture + top_marks).html_safe
  end

private

  def lecture_watched
    if @current_user.vimeos.where(video_id: @video.id).first
      link_to video_path(@video), class: 'lecture_icon watched', id: 'watched' do
        content_tag(:p, "You watched this 20 minutes ago and answered 10 of 10 questions correct", class:"tooltip")
      end
    else
      ""
    end
  end

  def part_watched
    if @current_user.vimeos.where(video_id: @video.id).where(completed: false).first
      link_to video_path(@video), class: 'lecture_icon part_watched', id: 'part_watched' do
        content_tag(:p, "You have not fully completed this lecture - Click here to continue where you left off", class:"tooltip")
      end
    else
      ""
    end
  end

  def not_watched
    if @current_user.vimeos.where(video_id: @video.id).first
      ""
    else
      link_to video_path(@video), class:"lecture_icon not_watched", id: 'not_watched' do
        content_tag(:p, "You have not yet watched this video", class:"tooltip")
      end
    end
  end

  def poor_score
    if @current_user.vimeos.where(video_id: @video.id).first
      question_ids = @video.question_ids
      if @current_user.user_questions.where("question_id IN (?)", question_ids).any?
        questions = @current_user.user_questions.where("question_id IN (?)", question_ids)
        total_count = questions.count
        correct_count = questions.where(correct_answer: true).count
        ratio = correct_count / total_count
        if 100 * ratio <= PASS_GRADE
          link_to video_path(@video), class: 'lecture_icon recommended_resit', id: 'recommend_resit' do
            content_tag(:p, "You only answered #{correct_count} of #{total_count} questions correct - You may benefit from retaking this lecture", class:"tooltip")
          end
        end
      else
        ""
      end
    else
      ""
    end
  end

  def resit_lecture
    if @current_user.vimeos.where(video_id: @video.id).where(completed: true).first
      link_to video_path(@video), class: 'lecture_icon resit', id: 'resit_video' do
        content_tag(:p, "Retake this lecture", class:"tooltip")
      end
    else
      ""
    end
  end

  def top_marks
    if @current_user.vimeos.where(video_id: @video.id).first
      question_ids = @video.question_ids
      if @current_user.user_questions.where("question_id IN (?)", question_ids).any?
        questions = @current_user.user_questions.where("question_id IN (?)", question_ids)
        total_count = questions.count
        correct_count = questions.where(correct_answer: true).count
        ratio = correct_count / total_count
        if ratio == 1
          link_to video_path(@video), class: 'lecture_icon top_marks', id: 'top_marks' do
            content_tag(:p, ("<span>Good Job</span>You anserwed all #{total_count} questions correctly and earned the maximum points avaliable.").html_safe, class:"tooltip")
          end
      end
      end
    else
      ""
    end
    # <a href="#" class="lecture_icon top_marks"><p class="tooltip"></p></a>
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

end
      