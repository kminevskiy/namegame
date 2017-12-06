module Serializer
    def self.stringify(object)
        JSON.dump(object)
    end
  
    def self.parse(string)
        if string && !string.empty?
            JSON.parse(string, { symbolize_names: true })
        else
            nil
        end
    end
end