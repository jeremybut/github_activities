class Repo
  include Her::Model
  extend CacheHelper
  belongs_to :user

  # Find repository
  def self.find(username, repo_id)
    fetch_or_get("repos/#{username}/#{repo_id}")
  end

  # Get the commit count for the repository owner and everyone else
  def last_year_commits_count
    repo = self.class.fetch_or_get("/repos/#{owner[:login]}/#{name}/stats/participation")
    repo.owner.sum if repo.owner # commits in the last 52 weeks
  end

  # Get the number of commits per hour in each day
  def commits_per_hour
    self.class.fetch_or_get("/repos/#{owner[:login]}/#{name}/stats/punch_card")
    # "25 total commits, during the 2:00pm hour on Tuesdays"    
  end

  # Get n commits the week of 'time'
  def stats_of_last_year
    arr = self.class.get("/repos/#{owner[:login]}/#{name}/stats/contributors")
    if arr.any? && arr
      weeks = arr.flat_map(&:weeks) 
      weeks.select {|x| x[:a] + x[:d] + x[:c] > 0 }
    end
  end

  def stats_graph_datas
    arr = self.class.get("/repos/#{owner[:login]}/#{name}/stats/contributors")
    weeks = arr.flat_map(&:weeks) if !arr.nil?
    weeks.map { |w| [Time.at(w[:w]).strftime('%Y')+"/"+Time.at(w[:w]).strftime('%m')+"/"+Time.at(w[:w]).strftime('%d'), w[:d] + w[:c] + w[:a] ] }
  end  

  def init_stats_graph
    # githubchart -i /path/to/file /path/to/svg
  end

  # Position to top n of the user
  def position
    username = owner[:login]
    contributors = self.class.fetch_or_get("repos/#{username}/#{name}/contributors")
    logins = contributors.map { |x| [x.login] }.flatten
    top_n = logins[0..10]
    top_n.include?(username) ? top_n.index(username) + 1 : false
  end

  # List languages
  def languages
    path = "repos/#{owner[:login]}/#{name}/languages"
    Rails.cache.fetch(path, expires_in: 1.day) do
      self.class.get_raw(path) do |parsed_data|
        parsed_data[:data].keys
      end
    end
  end
end
