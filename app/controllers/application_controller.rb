require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json, :xml

  protect_from_forgery

  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound do |exception|
      respond_to do |format|
        format.html {
          flash.now[:error] = t('error.record_not_found')
          render :template => 'site/404', :status => 404
        }
        format.xml  { head 404 }
        format.json { head 404 }
      end
    end
  end

  protected

  def random_sort_clause
    seed = session["#{controller_name}_random_sort_seed"] ||= rand(2147483647)
    direction = %w(asc desc).include?(params[:order]) ? params[:order].upcase : ''

    if ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3' || ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'postgresql'
      "RANDOM() #{direction}"
    else
      "RAND(#{seed}) #{direction}"
    end
  end

  def clear_random_sort_seed
    session["#{controller_name}_random_sort_seed"] = nil
  end

  def filter_sort_and_paginate(collection, default_order_random = false)
    collection = collection.tagged_with(params[:tag]) if params[:tag].present?

    if params[:column].eql?('random') || (params[:column].nil? && default_order_random)
      collection = collection.order(random_sort_clause)
    else
      clear_random_sort_seed
      begin
        collection = collection.sorty(params)
      rescue HeySorty::ArgumentError => e
        flash[:error] = t('error.invalid_sort_params')
      end
    end

    if params[:page] && params[:page].to_i.to_s != params[:page]
      params.delete(:page)
      flash[:error]  = t('error.invalid_page_number')
    end

    if params[:page] == 'all'
      collection.all
    else
      collection.paginate(:page => params[:page], :per_page => params[:per_page] || params[:grid] ? 28 : 30)
    end
  end


  def current_person
    current_user && current_user.person
  end
  helper_method :current_person

  def require_admin!
    authenticate_user! and return unless current_user
    unless current_user.admin?
      flash[:error] = t('error.access_denied')
      redirect_to root_path and return
    end
  end

  def page_title(value=nil)
    @page_title = value unless value.nil?

    if @page_title.nil?
      @page_title ||=
        case action_name.to_sym
        when :index
          controller_name.titleize
        when :new, :create
          t("title.model.new",:modelname => t('models.' + controller_name.singularize.humanize.downcase, :default => controller_name.singularize.humanize.downcase))
        when :edit, :update
          t("title.model.edit",:modelname => t('models.' + controller_name.singularize.humanize.downcase, :default => controller_name.singularize.humanize.downcase))
        when :destroy
          t("title.model.destroy",:modelname => t('models.' + controller_name.singularize.humanize.downcase, :default => controller_name.singularize.humanize.downcase))
        else
          begin
            get_resource_ivar.name
          rescue Exception => e
            controller_name.singularize.humanize.titleize
          end
        end
    else
      @page_title
    end
  end
  helper_method :page_title
end
