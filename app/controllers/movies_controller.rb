class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    redirect = 0
    
    if params[:sort_asc]
      session[:sort_asc] = params[:sort_asc]
      @sort_asc = params[:sort_asc]
    elsif session[:sort_asc]
      redirect = 1
      @sort_asc = session[:sort_asc]
    end
    
    @movies = @movies.order(@sort_asc)

    @checked_ratings = @all_ratings
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @checked_ratings = params[:ratings].keys
    elsif session[:ratings]
      redirect = 1
      @checked_ratings = session[:ratings].keys
    end
    
    @movies = @movies.where(rating: @checked_ratings)

  
    if redirect == 1
      flash.keep
      redirect_to movies_path(sort_asc: session[:sort_asc] , ratings: session[:ratings]) 

    end
  end
    
  def new
    # default: render 'new' template
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
