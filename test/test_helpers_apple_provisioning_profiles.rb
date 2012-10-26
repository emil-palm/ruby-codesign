require "helper"
require "ruby-codesign"
class TestHelpersAppleProvisioningProfiles < Test::Unit::TestCase
	context "a set of profiles" do
	    setup do
	    	@profiles = []
	    	@profiles << Grayhound::ProvisioningProfile.new({:appid => "HEXHASHEX.*"})
	    	@profiles << Grayhound::ProvisioningProfile.new({:appid => "HEXHASHEX.hex.texts"})
    	end

    	should "find a prov profile for com.example.app" do
			pps = Codesign::Helpers::Apple::ProvisioningProfiles.new
			valid_profiles = pps.select_profiles_for_bundle_id(@profiles, "com.example.app")
			assert_not_nil valid_profiles
			assert_instance_of Array, valid_profiles
			assert_equal 1, valid_profiles.count
    	end

    	should "not find a valid profile for com.example.app" do
    		pps = Codesign::Helpers::Apple::ProvisioningProfiles.new
    		valid_profiles = pps.select_profiles_for_bundle_id(@profiles.select { |p| p.appid == "HEXHASHEX.hex.texts" }, "com.example.app") 
    		assert_not_nil valid_profiles
    		assert_instance_of Array, valid_profiles
    		assert_equal 0, valid_profiles.count
    	end	

    	should "Should sort profiles based on how good they match find app specific profile" do
    		pps = Codesign::Helpers::Apple::ProvisioningProfiles.new
    		valid_profiles = pps.select_profiles_for_bundle_id(@profiles, "hex.texts")
    		assert_not_nil valid_profiles
    		assert_instance_of Array, valid_profiles
    		assert_equal 2, valid_profiles.count
    		assert_equal @profiles.reverse, valid_profiles
    	end
    end
end
	