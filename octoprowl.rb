require 'rubygems'
require 'bundler'
Bundler.require(:default, (ENV['RACK_ENV'] ||= :development.to_s).to_sym)

module Octoprowl
  MATCH_WORDS = %w(starr watch fork follow)

  class Runner
    def initialize(prowl_api_key, dry_run=false)
      if not dry_run
        @p = Prowl.new(:apikey => prowl_api_key, :application => 'Octoprowl')
        abort 'Error: Invalid Prowl API key' if not @p.valid?
      else
        puts 'Dry run...'
      end
      @cache = Cache.new
    end

    def scan(gh_feed_url, gh_username)
      last_scan = Time.parse(@cache.get("octoprowl:#{gh_username}:last_scan_time") || Time.now.to_s)
      f = Feedzirra::Feed.fetch_and_parse(gh_feed_url)
      abort "Error: Couldn't fetch feed (#{f})" if f.is_a? Fixnum
      num_matches = 0
      f.entries.each do |entry|
        num_matches = num_matches + 1 if process_entry(entry, gh_username, last_scan)
      end
      @cache.set("octoprowl:#{gh_username}:last_scan_time", Time.now)
      num_matches
    end

    @private
    def process_entry(entry, gh_username, last_scan)
      return if (entry.published <=> last_scan) == -1
      if entry.title =~ /(#{MATCH_WORDS.join('|')})[a-z]* #{gh_username}/
        if @p
          @p.add(:event => 'Awesome!', :description => entry.title)
        else
          puts "Matched: #{entry.title}"
        end
        return true
      end
    end
  end

  class Cache
    def initialize()
      uri = URI.parse(ENV['REDISTOGO_URL'] || ENV['REDISCLOUD_URL'] || ENV['MYREDIS_URL'] || 'http://localhost:6379')
      @cache = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end

    def set(key, value)
      @cache.set(key, value)
    end

    def get(key)
      @cache.get(key)
    end

    def delete(key)
       @cache.del(key)
    end
  end
end
