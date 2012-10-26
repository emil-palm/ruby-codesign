require 'grayhound'
module Codesign
	module Helpers
		module Apple
			class ProvisioningProfiles < Grayhound::DeveloperCenter::ProvisioningProfiles

				def select_profiles_for_bundle_id(profiles, bundle_id)
					valid_profiles = profiles.select { |pp| Globber.new(pp.appid.split(".",2)[1]) =~ bundle_id }.sort do |a,b| 
						a_globber = Globber.new(a.appid.split(".",2)[1])
						b_globber = Globber.new(b.appid.split(".",2)[1])

						a_globber.correctness(bundle_id) <=> b_globber.correctness(bundle_id)
					end
				end

				def profile_for_bundle_id(bundle_id)
					select_profiles_for_bundle_id(self, bundle_id)
				end

				def select_profiles_for_bundle_id_and_certificate(profiles, bundle_id, certificate)
					valid_profiles = select_profiles_for_bundle_id(profiles, bundle_id).select do |pp|
						pp.certificates certificate.length > 0
					end
				end

				def profile_for_bundle_id_and_certificate(bundle_id, certificate)
					select_profiles_for_bundle_id_and_certificate(self, bundle_id, certificate)
				end
			end
		end
	end
end