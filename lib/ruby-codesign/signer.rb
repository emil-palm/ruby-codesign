require 'tempfile'
require 'cfpropertylist'
module Codesign
	class Signer
		attr_accessor :application, :identity, :provisioning_file

		def self.sign_for_application(application)
			raise Codesign::Exception.new("#{application} is not a application") unless File.directory? application
			raise Codesign::Exception.new("#{application} is not a valid application") unless File.exists?("#{application}/Info.plist")
			plist = CFPropertyList::List.new(:file => "#{application}/Info.plist")
			data = CFPropertyList.native_types(plist.value)

			bundle_id = data['CFBundleIdentifier']

			provisioning_profiles = Codesign::Helpers::Apple::ProvisioningProfiles.new

			provisioning_file = nil
			identity = nil
			Codesign::Helpers::Identity::identities.each do |id|
				next if identity
				provisioning_profiles.profile_for_bundle_id(bundle_id).each do |pp|
					next if provisioning_file
					name = Regexp.escape id.name.gsub("\"", "")
					if pp.certificates.select { |p| p.subject.to_a[1][1].to_s.match(name) }.first != nil
						provisioning_file = pp.raw_data
					end
				end

				if provisioning_file
					identity = id
				end
			end

			if identity and provisioning_file
				return self.new(application, identity, provisioning_file)
			else
				raise Codesign::Exception.new("Couldnt find a certificate or provisioning_file for application")
			end
		end

		def initialize(application, identity, provisioning_file)
			self.application = application
			self.identity = identity
			self.provisioning_file = provisioning_file
		end

		def sign(outfile)
			io = StringIO.new
			tmp_file = Tempfile.new "foo" do |f|
  				f.write self.provisioning_file.string
			end
			
			Codesign.run("-sdk".to_sym, ["iphoneos", "PackageApplication", '-v', "\"#{self.application}\"", '-o',"\"#{outfile}\"", '--sign', "\"#{self.identity.name}\"", '--embed', tmp_file.path], io)
			tmp_file.unlink
			return io
		end
	end
end