class User
  include Her::Model
  has_many :repos
  primary_key :login
  alias_method :repositories, :repos

  # Find a user
  def self.find user
    super(user) 
    rescue Faraday::ResourceNotFound
  end

  # Search users
  def self.search(query)
      Search.users(query)
  end

  # Top 3 languages
  def top_languages(n)
    languages = repos.flat_map(&:languages)
    h = languages.each_with_object(Hash.new(0)) { |language, counts| counts[language] += 1 }
    Hash[h.sort_by { |_k, v| -v }[0..n - 1]]
  end

  # Get total number of commit per repository
  def total_number_of_commit(repo_id)
    arr = contributors_list repo_id
    arr.first[:contributions]
  end
end
