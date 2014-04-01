class AddQuestionCounterCacheToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :questions_count, :integer, default: 0, null: false

    ids = Set.new
    Question.all.each { |q| ids << q.video_id }
    ids.each do |video_id|
      Video.reset_counters(video_id, :questions)
    end

  end

  def down
    remove_column :videos, :questions_count
  end
end
