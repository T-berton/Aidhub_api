class Request < ApplicationRecord
    has_many :conversations, dependent: :destroy
    belongs_to :user

    # after_save :check_user_counter 

    before_create :set_published_at 

    def set_published_at
        self.published_at = Time.now
    end 
    # def check_user_counter
    #     if self.user_counter >= 5 && self.closed
    #         RepublishAlertJob.perform_in(24.hours.from_now,self.id)
    #     end 
    #   end

    acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

end
