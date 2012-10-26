require 'stringio'
module Codesign
	module Helpers
		module Identity
			class AutoIdentity < Codesign::Identity
				def self.from_row(row)
					AutoIdentity.new.tap do |ai|
						index,ai.id,ai.name = row.strip.split(" ",3)
						ai.name.gsub!(/(^\"|\"$)/, '')
					end
				end
			end

			def self.parse_io(io, matching=nil)
				[].tap do |array|
					io.rewind
					io.each do |row|
						next unless row.strip!.match(/^(\d+\))/i)
						ai = AutoIdentity.from_row(row)
						if matching
							array << ai if ai.name.match(matching) or ai.id.match(matching)
						else
							array << ai
						end
					end
				end
			end

			def self.identities(matching=nil)
				StringIO.new.tap do |io|
					Codesign.run(:security, ["find-identity","-v"], io)
					return self.parse_io(io, matching)
				end
			end
		end
	end
end