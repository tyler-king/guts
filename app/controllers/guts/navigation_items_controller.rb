require_dependency 'guts/application_controller'

module Guts
  # Navigation Items controller
  class NavigationItemsController < ApplicationController
    before_action :set_navigation_item, only: %i[show edit update destroy]
    before_action :set_navigation
    before_action :set_navigatable_models, exclude: :destroy

    # Displays a list of navigation items
    def index
      @navigation_items = @navigation.try(:navigation_items) || policy_scope(NavigationItem).all
    end

    # Shows a single navigation item
    def show
      authorize @navigation_item
    end

    # Creation of a new navigation item
    def new
      @navigation_item = NavigationItem.new
      authorize @navigation_item
    end

    # Editing of a navigation item
    def edit
      authorize @navigation_item
    end

    # Creates a navigation item through post
    # @note Redirects to #index if successfull or re-renders #new if not
    def create
      @navigation_item = NavigationItem.new navigation_item_params
      authorize @navigation_item

      if @navigation_item.save
        flash[:notice] = 'Navigation item was successfully created.'
        redirect_to navigation_navigation_items_path(@navigation)
      else
        render :new
      end
    end

    # Updates a navigation item through patch
    # @note Redirects to #index if successfull or re-renders #edit if not
    def update
      authorize @navigation_item

      if @navigation_item.update navigation_item_params
        flash[:notice] = 'Navigation item was successfully updated.'
        redirect_to navigation_navigation_items_path(@navigation)
      else
        render :edit
      end
    end

    # Destroys a single navigation item
    # @note Redirects to #index on success
    def destroy
      authorize @navigation_item
      @navigation_item.destroy

      flash[:notice] = 'Navigation item was successfully destroyed.'
      redirect_to navigation_navigation_items_path(@navigation)
    end

    # Generates a list of navigatable objects from the model provided
    # @see Guts::NavigatableConcern
    # @return [Object] JSON of navigatable objects
    def navigatable_objects
      model   = params[:model].constantize
      is_nav  = @navigatable.map { |m| m[:name] }.include?(params[:model])
      objects = model.all.map { |obj| { id: obj.id, format: obj.navigatable_format } } if is_nav

      render json: objects
    end

    private

    # Sets a navigation from the database using `id` param
    # @note This is a `before_action` callback
    # @private
    def set_navigation_item
      @navigation_item = NavigationItem.find params[:id]
    end

    # Sets a navigation parent from the database using `navigation_id` param
    # @note This is a `before_action` callback
    # @private
    def set_navigation
      @navigation = if params[:navigation_id]
                      Navigation.find params[:navigation_id]
                    else
                      @navigation_item.try :navigation
                    end
    end

    # Permits navigation nitem params from forms
    # @private
    def navigation_item_params
      params.require(:navigation_item).permit(
        :title,
        :custom,
        :position,
        :navigation_id,
        :navigatable_type,
        :navigatable_id,
        :site_id
      )
    end

    # Forces module load models so we can determine who is navigatable
    # @see Guts::NavigatableConcern
    # @private
    def set_navigatable_models
      Dir["#{Guts::Engine.root}/app/models/**/*.rb"].each { |model| require model }

      @navigatable = ActiveRecord::Base
                     .descendants
                     .map(&:name)
                     .select { |model| model.constantize.methods.include? :navigatable }
                     .map do |model|
                       {
                         name: model,
                         class: model.constantize,
                         readable: model.demodulize.underscore.humanize.capitalize
                       }
                     end
    end
  end
end
