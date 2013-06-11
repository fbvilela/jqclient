class LoginHistoriesController < ApplicationController
  # GET /login_histories
  # GET /login_histories.json
  def index
    @count_hash = LoginHistory.group(:login).count
    #@login_histories = LoginHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @login_histories }
    end
  end

  # GET /login_histories/1
  # GET /login_histories/1.json
  def show
    @login_history = LoginHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @login_history }
    end
  end

  # GET /login_histories/new
  # GET /login_histories/new.json
  def new
    @login_history = LoginHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @login_history }
    end
  end

  # GET /login_histories/1/edit
  def edit
    @login_history = LoginHistory.find(params[:id])
  end

  # POST /login_histories
  # POST /login_histories.json
  def create
    @login_history = LoginHistory.new(params[:login_history])

    respond_to do |format|
      if @login_history.save
        format.html { redirect_to @login_history, notice: 'Login history was successfully created.' }
        format.json { render json: @login_history, status: :created, location: @login_history }
      else
        format.html { render action: "new" }
        format.json { render json: @login_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /login_histories/1
  # PUT /login_histories/1.json
  def update
    @login_history = LoginHistory.find(params[:id])

    respond_to do |format|
      if @login_history.update_attributes(params[:login_history])
        format.html { redirect_to @login_history, notice: 'Login history was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @login_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /login_histories/1
  # DELETE /login_histories/1.json
  def destroy
    @login_history = LoginHistory.find(params[:id])
    @login_history.destroy

    respond_to do |format|
      format.html { redirect_to login_histories_url }
      format.json { head :no_content }
    end
  end
end
