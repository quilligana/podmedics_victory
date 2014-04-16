class Faq < ActiveRecord::Base

  validates :title, :content, presence: true

  #after_save :expire_faq_all_cache
  #after_destroy :expire_faq_all_cache

  #def self.all_cached
    #Rails.cache.fetch('Faq.all') { all }
  #end

  def self.for_members
    where(member_only: true)
  end

  #def expire_faq_all_cache
    #Rails.cache.delete('Faq.all')
  #end

end
