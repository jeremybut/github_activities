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
  # def commits_per_hour
  #   self.class.get("/repos/#{self.owner[:login]}/#{self.name}/stats/punch_card")
  #   # "25 total commits, during the 2:00pm hour on Tuesdays"    
  # end

  # Get n commits the week of 'time'
  def last_year_of_commit(username)
    arr = self.class.fetch_or_get("/repos/#{username}/#{name}/stats/commit_activity")
    Hash[arr.map { |key, _value| [key.total, Time.at(key.week)] }] if arr
  end

  # Position to top n of the user
  def position(username)
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
