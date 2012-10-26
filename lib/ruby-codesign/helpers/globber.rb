module Codesign
	module Helpers

		class Globber 
			def self.parse_to_regex(str)
				escaped = Regexp.escape(str).gsub('\*','(.*?)')
				Regexp.new "^#{escaped}$", Regexp::IGNORECASE
			end

			def initialize(str)
				@regex = self.class.parse_to_regex str
			end

			def =~(str)
				!!(str =~ @regex)
			end

			def regex
				@regex
			end

			def correctness(str)
				i = 0
				if match = self.regex.match(str)
					match.captures.each do |c| 
						i+=c.length 
					end

					i = (i - self.regex.source.length)
					if i == 0
						i = -1000
					end
				else
					i = 1000
				end
				return i
			end

		end
		
	end
end