require_dependency "guts/application_controller"

module Guts
  # Groups controller
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :edit, :update, :destroy]

    # Displays a list of groups
    def index
      @groups = Group.all
    end
    
    # Shows details about a single group
    def show
    end

    # Creation of a new group
    def new
      @group = Group.new
    end

    # Editing for a group
    def edit
    end

    # Creates a group through post
    # @note Redirects to #index if successfull or re-renders #new if not
    def create
      @group = Group.new group_params

      if @group.save
        redirect_to groups_path, notice: "Group was successfully created."
      else
        render :new
      end
    end

    # Updates a group through patch
    # @note Redirects to #index if successfull or re-renders #edit if not
    def update
      if @group.update(group_params)
        redirect_to groups_path, notice: "Group was successfully updated."
      else
        render :edit
      end
    end

    # Destroys a group
    # @note Redirects to #index on success
    def destroy
      @group.destroy
      redirect_to groups_url, notice: "Group was successfully destroyed."
    end

    private
    # Sets a group from the database using `id` param
    # @note This is a `before_action` callback
    # @private
    def set_group
      @group = Group.find params[:id]
    end

    # Permits group params from forms
    # @private
    def group_params
      params.require(:group).permit(:title, :slug)
    end
  end
end