class AiUsageService
  BASE_LIMIT = 3
  BONUS_LIMIT = 2

  def self.redis_key(user)
    "ai_usage:#{user.id}"
  end

  def self.usage_count(user)
    (REDIS.get(redis_key(user)) || 0).to_i
  end

  def self.today_limit(user)
    limit = BASE_LIMIT

    if user.posts.where(created_at: Time.zone.today.all_day).exists?
      limit += BONUS_LIMIT
    end

    limit
  end

  def self.remaining_count(user)
    [today_limit(user) - usage_count(user), 0].max
  end

  def self.increment(user)
    key = redis_key(user)

    REDIS.incr(key)

    unless REDIS.ttl(key).positive?
      REDIS.expire(key, seconds_until_midnight)
    end
  end

  def self.seconds_until_midnight
    tomorrow = Time.zone.tomorrow.beginning_of_day
    (tomorrow - Time.zone.now).to_i
  end
end