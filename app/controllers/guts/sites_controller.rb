require_dependency 'guts/application_controller'

module Guts
  # Sites controller
  class SitesController < ApplicationController
    before_action :set_site, except: %i[index new create]

    # Displays a list of sites
    def index
      @sites = policy_scope(Site).all
    end

    # Shows detaisl about a single site
    def show
      authorize @site
    end

    # Creation of a site
    def new
      @site = Site.new
      authorize @site
    end

    # Editting of a site
    def edit
      authorize @site
    end

    # Creates a site through post
    # @note Redirects to #index if successfull or re-renders #new if not
    def create
      @site = Site.new site_params
      authorize @site

      if @site.save
        flash[:notice] = 'Site was successfully created.'
        redirect_to sites_url
      else
        render :new
      end
    end

    # Updates a site through patch
    # @note Redirects to #index if successfull or re-renders #edit if not
    def update
      authorize @site

      if @site.update site_params
        flash[:notice] = 'Site was successfully updated.'
        redirect_to sites_url
      else
        render :edit
      end
    end

    # Destroys a site
    # @note Redirects to #index on success
    def destroy
      authorize @site
      @site.destroy
      redirect_to sites_url, notice: 'Site was successfully destroyed.'
    end

    # Sets a site as default
    def set_default
      authorize @site, :update?

      old_default = Site.find_by(default: true)
      old_default.update({ default: false }) unless old_default.nil?

      @site.update(default: true)

      flash[:notice] = 'Site was successfully set to default.'
      redirect_to sites_url
    end

    # Removes a site as default
    def remove_default
      authorize @site, :update?
      @site.update(default: false)

      flash[:notice] = 'Site was successfully changed to not default.'
      redirect_to sites_url
    end

    private

    # Sets a site from the database using `id` param
    # @note This is a `before_action` callback
    # @private
    def set_site
      @site = Site.find params[:id]
    end

    # Permits site params from forms
    # @private
    def site_params
      params.require(:site).permit(:name, :domain)
    end
  end
end
