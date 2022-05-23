class PasswordsController < ApplicationController
  #before_action :set_password, only: %i[ show edit update destroy ]

  # GET /passwords or /passwords.json
  def index
    @results = @results.nil? ? [] : @results
  end

  # GET /passwords/1 or /passwords/1.json
  def show
    redirect_to root_url
  end

  # "password"=>{"len"=>"6", "upcase_first"=>"0",
  #              "spec_char"=>"0", "upcase_any"=>"0", "num"=>"10"},
  # "results"=>"works!",
  # "commit"=>"Generate",
  # "controller"=>"passwords",
  # "action"=>"new"
  # GET /passwords/new
  def new
    logger.info ">>>>>>>>>> params: #{params}"
    if params[:password]
      Random.srand Time.now.to_i
      max = params[:password][:num].to_i
      @results = []
      while max > 0
        res = Generator.gen(params[:password][:len].to_i, params[:password][:upcase_first], params[:password][:spec_char], params[:password][:upcase_any])
        @results << res
        max -= 1
      end
    else
      if @results.nil?
        @results = ['No params...']
      end
    end
    respond_to do |format|
      format.html {render :index}
      format.js {render "index.js"
      }
    end
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
