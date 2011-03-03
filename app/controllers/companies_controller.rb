class CompaniesController < ApplicationController
  before_filter :assign_company, :except => [:index, :new, :create, :show, :tag]
  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @companies }
    end
  end

  def tag
    @tag = params[:tag]
    @companies = Company.tagged_with(@tag)

    render :action => :index
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id], :include => [:employees])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to(@company, :notice => 'Company was successfully created.') }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to(@company, :notice => 'Company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company.destroy
    flash[:success] = "#{@company.name} is no more."

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end


  def join
    @company.employees << current_person if current_person
    redirect_to :action => :show
  end

  def leave
    @company.employees.delete(current_person) if current_person
    redirect_to :action => :show
  end

  private

  def assign_company
    @company = Company.find(params[:id])
  end
end
