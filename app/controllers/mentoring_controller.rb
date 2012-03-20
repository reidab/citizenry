class MentoringController < ApplicationController
  before_filter :authenticate_user!, :only => [:profile_edit, :matches]

  def test
  end

  def search
    # if @mentor_tags.present?
    #   @people = Person.tagged_with(@mentor_tags, :on => :mentor_topic_tags, :any => true)
    # elsif @mentor_tags.present?
    #   @people = Person.tagged_with(@mentee_tags, :on => :mentee_topic_tags, :any => true)
    # end

    # render :text => params.inspect + "\n\n" + @people.inspect
  end

  def profile
    session[:mentoring_profile] = load_mentoring_params
    redirect_to mentoring_profile_welcome_path
  end

  def profile_welcome
    @mentoring = get_mentoring_data
    @matched_user = User.find_by_email(@mentoring[:contact][:email])
    unless current_user.present?
      @signin_data = SignInData.new(:email => @mentoring[:contact][:email], :provider => 'auto')
      session[:user_return_to] = mentoring_profile_edit_path
    end
  end

  def profile_edit
    @mentoring = get_mentoring_data
    @name = current_user.name || [@mentoring[:firstname], @mentoring[:lastname]].join(' ')
    @person = current_user.person || current_user.authentications.first.to_person || Person.new

    @person.name ||= @name
    @person.interested_mentor = @mentoring[:mentor_areas].present?
    @person.interested_mentee = @mentoring[:mentee_areas].present?

    @person.mentor_topic_models += @mentoring[:mentor_areas].map{|area| MentorshipTopic.find_or_create_by_slug(area) }
    @person.mentee_topic_models += @mentoring[:mentee_areas].map{|area| MentorshipTopic.find_or_create_by_slug(area) }
  end

  def matches
    if current_person
      if params[:kind] == 'mentors'
        mentor_rankings = Hash.new(0)
        current_person.mentee_topic_models.each do |topic|
          topic.mentors.each do |mentor|
            mentor_rankings[mentor] += 1
          end
        end
        @potential_mentors = mentor_rankings.keys.sort_by{|mentor| mentor_rankings[mentor]}.reverse
      elsif params[:kind] == 'mentees'
        mentee_rankings = Hash.new(0)
        current_person.mentor_topic_models.each do |topic|
          topic.mentees.each do |mentee|
            mentee_rankings[mentee] += 1
          end
        end
        @potential_mentees = mentee_rankings.keys.sort_by{|mentee| mentee_rankings[mentee]}.reverse
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  # Sign the user out, but preserve their mentoring session data
  def sign_out_preserve_mentoring
    if current_user.present?
      mentoring = get_mentoring_data
      sign_out current_user
      session[:mentoring_profile] = mentoring
    end
    redirect_to mentoring_profile_welcome_path
  end

  private

  def get_mentoring_data
    session[:mentoring_profile].presence || load_mentoring_params
  end

  def load_mentoring_params
    {}.tap do |mentoring|
      mentoring[:mentor_areas] = params[:mentor_area_details].present? ? params[:mentor_area_details].split(',') : []
      mentoring[:mentee_areas] = params[:mentee_area_details].present? ? params[:mentee_area_details].split(',') : []
      mentoring[:contact] = params.extract!(:firstname, :lastname, :companyname, :email, :phone)
    end
  end
end
