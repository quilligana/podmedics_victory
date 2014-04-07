class Permission

  def initialize(user)
    allow :static_pages, [:home, :about, :faqs, :library, :terms, :contact, :support]
    allow :sessions, [:new, :create, :omniauthcreate, :destroy]
    allow :courses, [:index]
    allow :users, [:new, :create]
    if user
      allow :dashboards, [:show]
      allow :users, [:show, :edit]
      allow :videos, [:show]
      allow :specialties, [:show]
      allow :questions, [:index, :specialty_index, :show, :answer, :result]
      allow :comments, [:create]
      allow_all if user.admin?
    end
    
  end

  def allow?(controller, action)
    @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
  end

  def allow(controllers, actions)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = true
      end
    end
  end

  def allow_all
    @allow_all = true
  end

end
