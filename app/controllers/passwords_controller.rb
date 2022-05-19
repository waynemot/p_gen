class PasswordsController < ApplicationController
  before_action :set_password, only: %i[ show edit update destroy ]

  # GET /passwords or /passwords.json
  def index
    @result = ""
  end

  # GET /passwords/1 or /passwords/1.json
  def show
  end

  # GET /passwords/new
  def new
    @password = Password.new
  end

  # GET /passwords/1/edit
  def edit
  end

  # POST /passwords or /passwords.json
  def create

  end

  # PATCH/PUT /passwords/1 or /passwords/1.json
  def update
    respond_to do |format|

    end
  end

  # DELETE /passwords/1 or /passwords/1.json
  def destroy
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_password
      @password = Password.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def password_params
      params.fetch(:password, {})
    end
end
