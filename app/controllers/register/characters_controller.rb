class Register::CharactersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"
  # GET /register/characters
  # GET /register/characters.json
  def index
    @register_characters = current_user.characters

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @register_characters }
    end
  end

  # GET /register/characters/1
  # GET /register/characters/1.json
  def show
    @register_character = current_user.characters.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @register_character }
    end
  end

  # GET /register/characters/new
  # GET /register/characters/new.json
  def new
    @temp_character = current_user.characters.find(:last)
    if @temp_character.nil?
      @register_character = Register::Character.new 
      @register_character.build_profile
    else
      @register_character = @temp_character.dup :include => :profile
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @register_character }
    end
  end

  # GET /register/characters/1/edit
  def edit
    @register_character = current_user.characters.find(params[:id])
  end

  # POST /register/characters
  # POST /register/characters.json
  def create
    @register_character = Register::Character.new(params[:register_character])
    @register_character.user = current_user

    respond_to do |format|
      if @register_character.save
        format.html { redirect_to @register_character, notice: 'Character was successfully created.' }
        format.json { render json: @register_character, status: :created, location: @register_character }
      else
        format.html { render action: "new" }
        format.json { render json: @register_character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /register/characters/1
  # PUT /register/characters/1.json
  def update
    @register_character = Register::Character.find(params[:id])

    respond_to do |format|
      if @register_character.update_attributes(params[:register_character])
        format.html { redirect_to @register_character, notice: 'Character was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @register_character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register/characters/1
  # DELETE /register/characters/1.json
  def destroy
    @register_character = current_user.characters.find(params[:id])
    @register_character.destroy

    respond_to do |format|
      format.html { redirect_to register_characters_url }
      format.json { head :no_content }
    end
  end
end
