require 'http'

module JSONParser
    def self.get_profiles
        HTTP.get('https://willowtreeapps.com/api/v1.0/profiles').parse
    end

    def self.prepare_for_storage
        profiles = self.get_profiles

        result = {
            current_team: [],
            past_team: [],
            all: [],
            matt: []
        }

        profiles.each do |profile|
            profile_image = profile['headshot']['url']

            if profile_image
                profile['headshot']['url'] = 'http:' + profile_image
            else
                next
            end

            if profile['jobTitle']
                result[:current_team] << Serializer.stringify(profile)
            else profile['jobTitle'].nil?
                result[:past_team] << Serializer.stringify(profile)
            end

            if profile['firstName'].match(/^ma(t|tt)\w*/i)
                result[:matt] << Serializer.stringify(profile)
            end

            result[:all] << Serializer.stringify(profile)
        end

        result
    end
end