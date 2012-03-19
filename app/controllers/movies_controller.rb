class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !params[:criteria]
      params[:criteria] = session[:criteria]
    else
      params[:ratings] = session[:ratings]
    end
    cond = ""
    if params[:ratings]
      params[:ratings].keys.each do |i|
        cond += '"'+i+'"' + " , "
      end
    end
    cond[-2] = ' ' if cond[-2] == "," if cond.length > 3
# debugger
    @all_ratings = Movie.getCategories
    @classes = {}
    if !params[:criteria]
      @movies = Movie.all(:conditions => cond.length > 2 ? "rating in (#{cond})" : "1=0")
    elsif (params[:criteria])
      @movies = Movie.all(:conditions => cond.length > 2 ? "rating in (#{cond})" : "1=0", :order => "#{params[:criteria]}")
      @classes = { params[:criteria] => "hilite" }
    end
    @criteria = params[:criteria]
    session[:criteria] = @criteria
    session[:ratings] = params[:ratings]
    [@movies, @classes, @all_ratings, session]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
