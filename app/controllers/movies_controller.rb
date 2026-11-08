class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # The four ratings the hw filter checkboxes offer.
  ALL_RATINGS = %w[G PG PG-13 R].freeze

  # Sorting keys that the Movie Title / Release Date header links may
  # request. The session stores the *last* chosen one so revisiting the
  # list keeps the ordering, exactly as the hw "remember settings" part
  # requires.
  SORT_KEYS = %w[title release_date].freeze

  # GET /movies or /movies.json
  def index
    # A request that provides neither the sort key nor a ratings filter
    # falls back to the remembered settings; otherwise what was sent wins.
    if params[:ratings].present?
      session[:ratings] = params[:ratings].to_unsafe_h.slice(*ALL_RATINGS)
    end
    if params[:sort].present? && SORT_KEYS.include?(params[:sort])
      session[:sort] = params[:sort]
    end

    checked = if params.key?(:ratings)
                params[:ratings].to_unsafe_h.keys & ALL_RATINGS
              elsif session[:ratings].present?
                session[:ratings].keys & ALL_RATINGS
              else
                ALL_RATINGS.dup
              end
    @selected_ratings = checked

    @all_ratings = ALL_RATINGS
    @sort = session[:sort]

    relation = Movie.where(rating: checked)
    ordered = case @sort
              when 'release_date' then relation.order(release_date: :asc)
              when 'title' then relation.order(title: :asc)
              else relation.order(:id)
              end
    @movies = ordered
    @hilite = { 'title' => 'hilite bg-warning',
                'release_date' => 'hilite bg-warning' }[@sort]
  end

  # GET /movies/1 or /movies.json
  def show
  end

  # GET /movies/new or /movies.json
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/:id
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
