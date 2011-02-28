class PeopleController < ApplicationController
  include Localness
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :assign_person, :except => [:index, :new, :create]

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
      query = params[:q]

      @found_people = []
      current_user.authentications.each do |auth|
        if auth.api_client
          @found_people += auth.api_client.search(query)
        end
      end

      @found_people.sort! {|a,b| localness(b) <=> localness(a)}
      @found_people = Person.all(:conditions => ['name LIKE ?', "%#{query}%"]) + @found_people

      # @rate_limit_status = current_user.twitter.get('/account/rate_limit_status')
    end

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

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
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end


  def claim
    if @person.user.present?
      flash[:error] = "This person has already been claimed."
      redirect_to(:action => 'show') and return
    end
  end

  private

  def assign_person
    @person = Person.find(params[:id])
  end
end
