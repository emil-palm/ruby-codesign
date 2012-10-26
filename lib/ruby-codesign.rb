module Codesign
	def self.run(application, args = [], output_buffer = STDOUT)
		IO.popen("xcrun #{application.to_s} #{args.join(" ")} 2>&1") do |io|
			begin
				while line = io.readline
					begin
						output_buffer << line
					rescue StandardError => e
						puts "Error from output buffer: #{e.inspect}"
						puts e.backtrace
					end
				end
			rescue EOFError
			end
		end

    	$?.exitstatus
	end

	class Exception < Exception
	end
end

require 'ruby-codesign/identity'
require 'ruby-codesign/helpers/base'
require 'ruby-codesign/signer'