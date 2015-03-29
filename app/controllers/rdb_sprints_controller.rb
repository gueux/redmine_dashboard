class RdbSprintsController < ApplicationController
  unloadable
  model_object Sprint

  helper :rdb_dashboard

  before_filter :find_project_by_project_id, :only => [:index, :new, :create, :edit, :update, :delete, :close]

  def new
    @sprint = @project.sprints.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create 
    @sprint = @project.sprints.build
    if params[:sprint]
      attributes = params[:sprint].dup
      @sprint.safe_attributes = attributes
    end

    if request.post?
      if @sprint.save
        respond_to do |format|
          format.js  { render :js => "window.location.href='" + rdb_scrumban_path( :id => @project.identifier ) + "'" }
        end
      else
        respond_to do |format|
          format.js   { render :action => 'new' }
        end
      end
    end
  end

  def edit
    @sprint = @project.sprints.find(params[:id])
    respond_to do |format|
      format.js   { render :action => 'edit' }
    end
  end

  def update 
    @sprint = @project.sprints.find(params[:id])
    respond_to do |format|
      format.js  { render :js => "window.location.href='" + rdb_scrumban_path( :id => @project.identifier ) + "'" }
    end
  end

  def delete
    @sprint = @project.sprints.find(params[:id])
    @sprint.destroy

    respond_to do |format|
      format.html { redirect_back_or_default rdb_scrumban_path( :id => @project.identifier ) }
    end
  end

  def close
    @sprint = @project.sprints.find(params[:id])
    return flash_error(:text_sprint_close_confirmation) if @sprint.has_open_issues?
    if @sprint.save
      respond_to do |format|
        format.html { redirect_back_or_default rdb_scrumban_path( :id => @project.identifier ) }
      end
    end
  end

  def flash_error(sym, options = {})
    flash.now[:rdb_error] = I18n.t(sym, options).html_safe
    Rails.logger.info "Render Rdb flash error: #{sym}"
    options[:update] ? render('index.js') : render('error.js')
  end
end
