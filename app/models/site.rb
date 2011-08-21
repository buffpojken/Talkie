require 'digest/sha1'
class Site < ActiveRecord::Base
  
  before_create :set_subdomain, :make_auth_hash  
  validates_uniqueness_of :subdomain
  
  after_commit :set_redis_key

  def key(spec)
    return "site-#{self.subdomain.to_s}-#{spec.to_s}"
  end
  
  def messages(limit=10)
    $redis.lrange(key('messages'), 0, 10).map{|a| b = JSON.parse(a); b['date'] = Time.at(b['timestamp'].to_i/1000); b }.reverse
  end
  
  def users
    []
  end
  
  private
  
  def set_subdomain
    self.subdomain = name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').gsub(/[^\s\w\d]/, "").gsub(/\s+/, "-").downcase.to_s
  end

  def make_auth_hash
    self.auth_hash = Digest::SHA1.hexdigest(self.object_id.to_s + Time.now.to_i.to_s + self.name.to_s)
  end

  def set_redis_key
    $redis.hmset key('chat'), 
      'active', 1, 
      'site_id', self.id, 
      'user_id', self.user_id, 
      'site_name', self.name, 
      'authkey', self.auth_hash
  end
  
end
