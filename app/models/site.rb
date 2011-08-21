##### Author: Daniel Sundström  #####
##### Date: August 21, 2011 - Aug:08:58#####
##### License: MIT License    #####
require 'digest/sha1'
class Site < ActiveRecord::Base
  
  # When creating a site, make sure we generate a proper subdomain and an authorizationhash
  before_create :set_subdomain, :make_auth_hash  
  # Ensure we don't have two sites with same unique subdomain
  validates_uniqueness_of :subdomain
  # Remove redis-based data for this site when deleting it
  before_destroy :cleanup
  # Set the redis-key on after_commit to make sure the ID is properly set
  after_commit :set_redis_key

  # Format a redis-compliant key with the provded suffix
  def key(spec)
    return "site-#{self.subdomain.to_s}-#{spec.to_s}"
  end
  
  # Load the last 10 messages for this site from redis, parse the JSON (redis can only store strings, 
  # all data is stored as JSON), and parse the timestamp to a proper Ruby Time-object. Finally, reverse the list
  # since the datastructure in redis will be sorted created_at, while we want created_at desc since we grad from head of list
  def messages(limit=10)
    $redis.lrange(key('messages'), 0, 10).map{|a| b = JSON.parse(a); b['date'] = Time.at(b['timestamp'].to_i/1000); b }.reverse
  end
  
  # Do not load currently online users from Redis at the moment, since we can't render it properly. 
  # In order to keep public class API, return an empty list
  def users
    []
  end
  
  private
  
  # Take the name of the site, and format it in an UTF8-intelligent way (converting for example davén to daven), downcase it
  # and use it as the subdomain
  def set_subdomain
    self.subdomain = name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').gsub(/[^\s\w\d]/, "").gsub(/\s+/, "-").downcase.to_s
  end

  # Calculate a random SHA1-hash to use as unique identifier for this specific site-object, globally across all versions of Talkie
  def make_auth_hash
    self.auth_hash = Digest::SHA1.hexdigest(self.object_id.to_s + Time.now.to_i.to_s + self.name.to_s)
  end

  # Store a representation of this site in redis as a hash-object, since NodeJS will require it to access the site,
  # validate it and route messages to it properly
  def set_redis_key
    $redis.hmset key('chat'), 
      'active', 1, 
      'site_id', self.id, 
      'user_id', self.user_id, 
      'site_name', self.name, 
      'authkey', self.auth_hash
  end

  # When deleting a site, remove the representations of it from redis
  def cleanup
    $redis.del key('chat')
    $redis.del key('messages')
  end
  
end
