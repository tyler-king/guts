require_dependency 'guts/application_controller'

module Guts
  # Options controller
  class OptionsController < ApplicationController
    before_action :set_option, only: %i[show edit update destroy]
    before_action :set_per_page, only: :index
    
    # Display a list of options
    def index
      @options = policy_scope(Option).paginate(page: params[:page], per_page: @per_page)
    end

    # Show a single options
    def show
      authorize @option
    end

    # Creation of a new option
    def new
      @option = Option.new
      authorize @option
    end

    # Editing of an option
    def edit
      authorize @option
    end

    # Creates an option through post
    # @note Redirects to #index if successfull or re-renders #new if not
    def create
      @option = Option.new option_params
      authorize @option

      if @option.save
        flash[:notice] = 'Option was successfully created.'
        redirect_to edit_option_path(@option)
      else
        render :new
      end
    end

    # Updates an option through patch
    # @note Redirects to #index if successfull or re-renders #edit if not
    def update
      authorize @option

      if @option.update option_params
        flash[:notice] = 'Option was successfully updated.'
        redirect_to edit_option_path(@option)
      else
        render :edit
      end
    end

    # Destroys an option
    def destroy
      authorize @option
      @option.destroy

      flash[:notice] = 'Option was successfully destroyed.'
      redirect_to options_path
    end

    private

    # Sets a coption from the database using `id` param
    # @note This is a `before_action` callback
    # @private
    def set_option
      @option = Option.find params[:id]
    end

    # Permits option params from forms
    # @private
    def option_params
      params.require(:option).permit(:key, :value, :site_id)
    end

    # Gets the per-page value to use
    # @note Default is 30
    # @private
    def set_per_page
      @per_page = params[:per_page] || 30
    end
  end
end
