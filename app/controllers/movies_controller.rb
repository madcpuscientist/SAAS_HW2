class MoviesController < ApplicationController

  # def movie_params
  #   params.require(:movie).permit(:title, :rating, :description, :release_date)
  # end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    if params[:sort].nil? && params[:ratings].nil? &&
        (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end

    @sort = params[:sort]
    @ratings = params[:ratings] 
    if @ratings.nil?
      ratings = Movie.ratings 
    else
      ratings = @ratings.keys
    end

     @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
           all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating) 
           all_ratings
     end
      
    if !@sort.nil?
      begin
        @movies = Movie.order("#{@sort} ASC").find_all_by_rating(ratings)
      rescue ActiveRecord::StatementInvalid
        flash[:warning] = "Movies cannot be sorted by #{@sort}."
        @movies = Movie.find_all_by_rating(ratings)
      end
    else
      @movies = Movie.find_all_by_rating(ratings)
    end

    session[:sort] = @sort
    session[:ratings] = @ratings
  end

  def new
    session.clear
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
