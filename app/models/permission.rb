class Permission

  def initialize(user)
    allow :static_pages, [:home, :about, :faqs, :library, :terms, :contact, :support, :plans]
    allow :sessions, [:new, :create, :omniauthcreate, :destroy]
    allow :password_resets, [:create]
    allow :courses, [:index]
    allow :users, [:new, :create]
    if user
      allow :dashboards, [:show]
      allow :users, [:show]
      allow :users, [:edit, :update] do |resource|
        resource.id == user.id
      end
      allow :videos, [:show]
      allow :hosted_files, [:video, :audio, :slides]
      allow :specialties, [:show]
      allow :questions, [:index, :specialty_index, :show, :answer, :result]
      allow :comments, [:create, :vote, :accept, :destroy]
      allow :specialty_questions, [:show, :index, :create, :destroy, :load]
      allow :notes, [:create, :update, :load]
      allow_all if user.admin?
    end
    
  end

  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end

  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

  def allow_all
    @allow_all = true
  end

end
