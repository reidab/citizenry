class EmploymentsController < ApplicationController
  include Localness
  def new
    if params[:q].present?
      @twitter_people = current_user.twitter.get("/users/search?q=#{CGI::escape params[:q]}&per_page=20")
      @twitter_people.sort! {|a,b| localness(b) <=> localness(a)}

      @existing_people =  Person.all(:conditions => {
                            :twitter => @found_people.map{|p| p['screen_name']}
                          })

      @rate_limit_status = current_user.twitter.get('/account/rate_limit_status')
    end
  end
end
