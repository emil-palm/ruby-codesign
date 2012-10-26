require "helper"
require "ruby-codesign"
class TestHelpersIdentity < Test::Unit::TestCase
	context "a identity" do
	    setup do
	    	@io = StringIO.new
	    	@io << "  1) EDE3624089D6523D0857FB111E83A8D767FF987E \"iPhone Developer: Emil Palm (5GJ7LC8A2T)\"\n"
			@io << "  2) 73BE89F61257393C46CAD816EF717026B9C76D13 \"Apple Development IOS Push Services: graymatter.test.xir\"\n"
			@io << "  3) F51D2904B9CD1F9E5964B88C741E4AE7EAB9A291 \"iPhone Distribution: Graymatter\"\n"
			@io << "     3 valid identities found"
    	end

    	should "parse all identities" do
    		identities = Codesign::Helpers::Identity::parse_io(@io)
    		assert_not_nil identities
    		assert_instance_of Array, identities
	  		assert_equal 3,identities.count 
	  	end

	  	should "parse only emil identities" do
	  		identities = Codesign::Helpers::Identity::parse_io(@io, /Emil Palm/i)
	  		assert_not_nil identities
    		assert_instance_of Array, identities
	  		assert_equal 1,identities.count 
	  	end

	  	should "parse only identifier EDE3624089D6523D0857FB111E83A8D767FF987E" do
	  		identities = Codesign::Helpers::Identity::parse_io(@io, /EDE3624089D6523D0857FB111E83A8D767FF987E/) 
	  		assert_not_nil identities
    		assert_instance_of Array, identities
	  		assert_equal 1,identities.count
	  	end

	  	should "parse identies matching none" do
	  		identities = Codesign::Helpers::Identity::parse_io(@io, /asdf/) 
	  		assert_not_nil identities
    		assert_instance_of Array, identities
	  		assert_equal 0,identities.count
	  	end

	  	should "load from xcrun" do 
	  		identities = Codesign::Helpers::Identity::identities(/asdf/) 
	  		assert_not_nil identities
    		assert_instance_of Array, identities
	  		assert_equal 0,identities.count
	  	end
    end
end
