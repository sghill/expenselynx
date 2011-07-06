class ProjectsController < ApplicationController

  respond_to :html

  def index
    @projects = current_user.projects
  end

  def show
    @project = current_user.projects.find(params[:id])
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:id])
    @project.update_attributes(params[:project])
    respond_with(@project)
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.create(params[:project])
    respond_with(@project)
  end
end
