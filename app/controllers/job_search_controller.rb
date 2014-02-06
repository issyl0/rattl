class JobSearchController < ApplicationController

  def index
  end

  def create
    @@vacancies = Array.new()
    api_root = "http://api.lmiforall.org.uk/api/v1/vacancies/search?limit=50"
    keywords = "&keywords=#{job_search_params['search']}"
    
    JSON.parse(RestClient.get(api_root + keywords)).each do |i|
      @@vacancies.push(i)
    end
    
    redirect_to job_search_list_path
  end

  def list
  end

  helper_method :vacancies
  def vacancies
    @@vacancies
  end

  private
  def job_search_params
    params.require(:job_search).permit(:search, :near_me)
  end
end