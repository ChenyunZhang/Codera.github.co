class User < ApplicationRecord
    has_many :questions, -> {order ("updated_at DESC")}, dependent: :destroy
    accepts_nested_attributes_for :questions, allow_destroy: true
    has_many :answers, through: :questions

################################ Validation ###########################################
    before_save {self.email = email.downcase } #or { email.downcase!}
    validates :first_name, :last_name, presence: true, length: { maximum: 50 }
    validates :email, presence: true,
                    length: { maximum: 50 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i},
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, length: { minimum: 6 }, allow_blank:true;

###########################################################################################
    def full_name
        "#{self.first_name} #{self.last_name}"
    end

    def question_arr
        arr = []
        self.answers.each do |answer|
            arr << answer.question
        end
        arr.uniq
    end




    # <% @user.question_arr.each do |question|%>
    #     <li>
    #         <%=link_to question.title, question_path(@current_user, @user.question_arr.find(title: "question"))%>
    #     </li>
    # <%end%>

    

end
