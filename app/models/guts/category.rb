module Guts
  # Category model
  class Category < ApplicationRecord
    extend FriendlyId
    include NavigatableConcern
    include MultisiteScopeConcern

    validates :title, presence: true, length: { minimum: 3 }

    belongs_to :site
    has_many :categorizations
    has_many :contents, through: :categorizations
    has_many :media, as: :filable, dependent: :destroy
    has_many :metafields, as: :fieldable, dependent: :destroy

    friendly_id :title, use: %i(slugged scoped finders), scope: :site_id
    navigatable :title, format: ':title'

    # Updates slug if title changes
    # @return [Boolean]
    def should_generate_new_friendly_id?
      title_changed?
    end
  end
end
