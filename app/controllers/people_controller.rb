class PeopleController < ApplicationController
  include Localness
  before_filter :authenticate_user!, :except => [:index, :show]
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all(:order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    if params[:q].present?
      @found_people = current_user.twitter.get("/users/search?q=#{CGI::escape params[:q]}&per_page=20")
      @found_people.sort! {|a,b| localness(b) <=> localness(a)}

      @existing_people =  Person.all(:conditions => {
                            :twitter => @found_people.map{|p| p['screen_name']}
                          })

      @rate_limit_status = current_user.twitter.get('/account/rate_limit_status')
    end

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.xml
  def create
    if params[:from_twitter].present?
      @person = Person.from_twitter(params[:from_twitter], current_user.twitter)
    else
      @person = Person.new(params[:person])
#      @person.user = current_user unless current_user.try(:person).present?
    end

    respond_to do |format|
      if @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully created.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
end
