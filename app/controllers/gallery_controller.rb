class GalleryController < ApplicationController
  helper_method :model_from
  # GET /gallery/:model(/:tag/tag)
  # GET /gallery/:model(/:tag/tag).json
  def index
    begin
      if model.to_sym == :all
        taggings = ActsAsTaggableOn::Tagging.arel_table
        @imgs = ActsAsTaggableOn::Tagging.where(taggings[:tagger_type].eq("User")).includes(:taggable=>[:image=>[:user=>[:character=>:profile]]])
        @imgs = @imgs.map{ |t| t.taggable }.uniq
      else
        @imgs = eval "Register::Upload#{model.classify}.where_public"
        @imgs = @imgs.tagged_with(tag) if tag
        @imgs = @imgs.all
      end
    rescue
      redirect_to root_path
    end
  end

  # GET /gallery/:model/:id
  # GET /gallery/:model/:id.json
  def show
    @img = eval "Register::Upload#{model.classify}.find_by_id(params[:id])"
  end

  # PUT /gallery/:model/:id
  # PUT /gallery/:model/:id.json
  def update
    @img = eval "Register::Upload#{model.classify}.find_by_id(params[:id])"
    @img.tag_list = params[:form_tag][:tag_list]
    @img.save
    redirect_to gallery_path
  end
  
  private
  def model
    @model ||= params[:model]
  end
  def tag
    @tag ||= params[:tag]
  end
  def model_from(img)
    @model_from ||= img.class.name.underscore.split("_").last
  end
end
