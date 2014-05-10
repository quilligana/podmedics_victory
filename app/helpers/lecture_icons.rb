class LectureIcons

  def initialize(video, current_user, template)
    @template = template
    @video = video
    @current_user = current_user
  end

  def show_lecture_icons
    (lecture_watched + not_watched + part_watched + user_performance +
    resit_lecture).html_safe
  end

private

  def lecture_watched
    if check_vimeo && check_vimeo.completed == true
      link_to video_path(@video), class: 'lecture_icon watched', id: 'watched' do
        content_tag(:p, "You watched this #{time_ago_in_words(check_vimeo.
                          updated_at)} ago #{return_results}", class:"tooltip")
      end
    else
      ""
    end
  end

  def return_results
    if check_questions.any?
      question_results = QuestionResults.new(check_questions, @video.question_ids.count)
      "and answered #{question_results.correct_count} of #{question_results.
        total_count} questions correct"
    end
  end

  def part_watched
    if check_vimeo && check_vimeo.completed == false
      link_to video_path(@video), class: 'lecture_icon part_watched', id: 'part_watched' do
        content_tag(:p, "You have not fully completed this lecture - 
                        Click here to continue where you left off 
                        #{time_ago_in_words(check_vimeo.updated_at)} ago", 
                        class:"tooltip")
      end
    else
      ""
    end
  end

  def not_watched
    if check_vimeo
      ""
    else
      link_to video_path(@video), class:"lecture_icon not_watched", id: 'not_watched' do
        content_tag(:p, "You have not yet watched this video", class:"tooltip")
      end
    end
  end

  def user_performance
    if check_vimeo  && check_vimeo.completed == true
      if check_questions.any? 
        question_results = QuestionResults.new(check_questions, @video.question_ids.count)
        display_performance_icons(question_results)
      else
        ""
      end
    else
      ""
    end
  end

  def display_performance_icons(question_results)
    if question_results.bad_result?
      link_to video_path(@video), class: 'lecture_icon recommend_resit', id: 'recommend_resit' do
        content_tag(:p, "You only answered #{question_results.correct_count} of 
                        #{question_results.total_count} questions correct - You may 
                        benefit from retaking this lecture", class:"tooltip")
      end
    elsif question_results.top_result?
      link_to video_path(@video), class: 'lecture_icon top_marks', id: 'top_marks' do
        content_tag(:p, ("<span>Good Job</span>You anserwed all 
                      #{question_results.total_count} questions correctly and earned the
                      maximum points avaliable.").html_safe, class:"tooltip")
      end
    end
  end

  def resit_lecture
    if check_vimeo && check_vimeo.completed == true
      link_to video_path(@video), class: 'lecture_icon resit', id: 'resit_video' do
        content_tag(:p, "Retake this lecture", class:"tooltip")
      end
    else
      ""
    end
  end

  def check_vimeo
    Vimeo.cached_find(@current_user.id, @video.id)
  end

  def check_questions
    @current_user.user_questions.where("question_id IN (?)", @video.question_ids)
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

end  