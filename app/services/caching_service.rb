class CachingService
    attr_reader :redis

    def initialize
        @redis = ConnectionPool.new(size: 5, timeout: 5) do
            uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/")
            
            Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
        end

        build_cache
    end

    def cache_exists?
        execute { |c| c.exists 'profiles' }
    end

    def build_cache
        unless cache_exists?
            profiles = JSONParser.prepare_for_storage
            all_profiles = profiles[:all]
            matt = profiles[:matt]
            current_team = profiles[:current_team]
            past_team = profiles[:past_team]
            
            all_profiles.each do |profile|
                execute do |c|
                    c.sadd('all', profile)
                end
            end

            current_team.each do |profile|
                execute do |c|
                    c.sadd('current_team', profile)
                end
            end

            past_team.each do |profile|
                execute do |c|
                    c.sadd('past_team', profile)
                end
            end

            matt.each do |profile|
                execute do |c|
                    c.sadd('matt', profile)
                end
            end

            %w(all matt current_team past_team).each do |namespace|
                execute { |c| c.expire namespace, 86400 }
            end

            return true
        end
        false
    end

    def get_random_profiles(team_type, n)
        return unless %w(all matt current_team past_team).include? team_type

        serialized_profiles = execute { |c| c.srandmember team_type, n }

        serialized_profiles.map do |profile|
            Serializer.parse(profile)
        end
    end

    private

    def execute
        redis.with { |connection| yield connection }
    end
end