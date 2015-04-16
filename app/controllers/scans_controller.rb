class ScansController < ApplicationController

  # GET /scans
  # GET /scans.json
  def index
    @scans = Scan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scans }
    end
  end

  # GET /scans/1
  # GET /scans/1.json
  def show
    @scan = Scan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scan }
    end
  end

  # GET /scans/new
  # GET /scans/new.json
  def new
    @scan = Scan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scan }
    end
  end

  # GET /scans/1/edit
  def edit
    @scan = Scan.find(params[:id])
  end

  # POST /scans
  # POST /scans.json
  def create
    @scan = Scan.new(params[:scan])

    respond_to do |format|
      if @scan.save
        format.html { redirect_to @scan, notice: 'Scan was successfully created.' }
        format.json { render json: @scan, status: :created, location: @scan }
      else
        format.html { render action: "new" }
        format.json { render json: @scan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scans/1
  # PUT /scans/1.json
  def update
    @scan = Scan.find(params[:id])

    respond_to do |format|
      if @scan.update_attributes(params[:scan])
        format.html { redirect_to @scan, notice: 'Scan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scans/1
  # DELETE /scans/1.json
  def destroy
    @scan = Scan.find(params[:id])
    @scan.destroy

    respond_to do |format|
      format.html { redirect_to scans_url }
      format.json { head :no_content }
    end
  end
end
