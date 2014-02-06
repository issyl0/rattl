class JobSearchController < ApplicationController

  def index
  end

  def create
    @@vacancies = Array.new()
    api_root = "http://api.lmiforall.org.uk/api/v1/vacancies/search?limit=50"
    keywords = "&keywords=#{job_search_params['search']}"
    if job_search_params['near_me'] == "1"
      postcode = "&postcode=#{UserDetail.where(user_id: current_user.id).first.postcode.gsub(/\s+/, "")}"
    end

    postcode ? query_with_location(api_root, keywords, postcode) : query_without_location(api_root, keywords)

    redirect_to job_search_list_path
  end

  def list
  end

  def query_with_location(api_root, keywords, postcode)
    JSON.parse(RestClient.get(api_root + keywords + postcode)).each do |v|
      @@vacancies.push(v)
    end
  end

  def query_without_location(api_root, keywords)
    JSON.parse(RestClient.get(api_root + keywords)).each do |v|
      @@vacancies.push(v)
    end
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