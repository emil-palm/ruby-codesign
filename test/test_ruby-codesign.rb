require 'helper'
require 'ruby-codesign'
class TestRubyCodesign < Test::Unit::TestCase
	context "general" do
		setup do 
		end

		should "run xcrun gcc without arguments" do
			io = StringIO.new
			assert_equal 64, Codesign.run(:xcrun, [], io)
		end

	  	should "find identity and cert for application" do
	  		x = Codesign::Signer.sign_for_application("/majs/moo/build/BLOCKET_QA-iphoneos/iphone QA.app")
	  		assert_not_nil x
	  		assert_instance_of Codesign::Signer, x
		end
	end
end
