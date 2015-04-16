class CelebsController < ApplicationController

  def search

    @celebs = Celeb.search(params[:q]).order('metric_height').page params[:page]

    @maximum = 0

    if !@celebs.blank?
      @maximum = Celeb.search(params[:q]).maximum("metric_height")
    end


    str = URI.unescape(params[:q]).gsub('-', ' ')

    parts = str.strip.split(/\s*,\s*/)

    parts.each do |item|
      customArray = item.split(/^(\w.+):([0-9]{1,7}(?:\.[0-9]{0,2})?)(\s?\w+)*$/i)

      #Rails.logger.debug("##############STR################: #{customArray}")

      customName = customArray[1].to_s.strip.titlecase
      customNumber = customArray[2].to_f
      customUnit = customArray[3].to_s.strip.downcase

      metricHeight = nil

      if customUnit == 'ft' || customUnit == 'feet' || customUnit == 'f'

        ftHeight = customNumber

        metricHeight = ftHeight * (0.3048/1)

      end

      if customUnit == 'meters' || customUnit == 'metres' || customUnit == 'm' || customUnit == 'cm' || customUnit == 'centimeters' || customUnit == 'centimetres'
        if customUnit == 'cm' || customUnit == 'centimeters' || customUnit == 'centimetres'
          metricHeight = customNumber / 100
        else
          metricHeight = customNumber
        end
      end

      if !metricHeight.nil?

        c = Celeb.new

        c.temp = true
        c.full_name = customName
        c.metric_height = metricHeight

        if(metricHeight > @maximum)
          @maximum = metricHeight
        end

        @celebs << c

      end

    end

    @search_str = ''

    if params[:q].blank? == false
      @search_str = params[:q].gsub('-', ' ');
    end

    Twitter.configure do |config|
      config.consumer_key = 'vaJajfUD2BEjX59tPLRog'
      config.consumer_secret = 'vjD8lIFLCW6okprtwWSj1iAnU54KT0oca7NV722nTw'
      config.oauth_token = '6074722-TtOZkdij4WgO25Rw3DIO1nYAZshYKh9qsB7S75IDg2'
      config.oauth_token_secret = 'a0jHGkLmBrpH6FeSQq2v2KytHTZ7hmtilHBIupFI'
    end

    @celebs.each do |celeb|
      # If we have a twitter id fetch tweets
      if celeb.twitter_id.blank? == false && (celeb.updated_at+1.days < DateTime.now || celeb.tweets.blank?)
        c = Celeb.find_or_initialize_by_full_name(celeb.full_name)
        uid = c.twitter_id
        c.tweets = Twitter.user_timeline(uid).to_json
        celeb.tweets = c.tweets
        c.save
      end
    end

    @celebs.sort! { |a,b| a.metric_height <=> b.metric_height }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @celebs }
    end
  end

  # GET /celebs
  # GET /celebs.json
  def index

    # @celebs = Celeb.page params[:page]

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @celebs }
    #end
  end

  # GET /celebs/1
  # GET /celebs/1.json
  def show
    @celeb = Celeb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @celeb }
    end
  end

  # GET /celebs/new
  # GET /celebs/new.json
  def new
    @celeb = Celeb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @celeb }
    end
  end

  # GET /celebs/1/edit
  def edit
    @celeb = Celeb.find(params[:id])
  end

  # POST /celebs
  # POST /celebs.json
  def create
    @celeb = Celeb.new(params[:celeb])

    respond_to do |format|
      if @celeb.save
        format.html { redirect_to @celeb, notice: 'Celeb was successfully created.' }
        format.json { render json: @celeb, status: :created, location: @celeb }
      else
        format.html { render action: "new" }
        format.json { render json: @celeb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /celebs/1
  # PUT /celebs/1.json
  def update
    @celeb = Celeb.find(params[:id])

    respond_to do |format|
      if @celeb.update_attributes(params[:celeb])
        format.html { redirect_to @celeb, notice: 'Celeb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @celeb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /celebs/1
  # DELETE /celebs/1.json
  def destroy
    @celeb = Celeb.find(params[:id])
    @celeb.destroy

    respond_to do |format|
      format.html { redirect_to celebs_url }
      format.json { head :no_content }
    end
  end
end