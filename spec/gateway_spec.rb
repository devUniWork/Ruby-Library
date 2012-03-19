require 'spec_helper'

TEST_USER = "TEST"
TEST_TOKEN = "TEST"
TEST_LOCAL = true

describe FatZebra::Gateway do
	before :each do
		# Setup the gateway for testing
		server = TEST_LOCAL == true ? "fatapi.dev" : "gateway.fatzebra.com.au"
		@gw = FatZebra::Gateway.new(TEST_USER, TEST_TOKEN, server, {:secure => !TEST_LOCAL})
	end

	it "should require username and token are provided" do
		lambda { FatZebra::Gateway.new("test", nil) }.should raise_exception(FatZebra::InvalidArgumentError)
	end

	it "should require that the gateway_server arg is not nil or empty" do
		lambda { FatZebra::Gateway.new("test", "test", "") }.should raise_exception(FatZebra::InvalidArgumentError)	
	end

	it "should load a valid instance of the gateway" do
		@gw.ping.should be_true
	end

	it "should perform a purchase" do
		result = @gw.purchase(10000, {:card_holder => "Matthew Savage", :number => "5123456789012346", :expiry => "05/2013", :cvv => 123}, "TEST#{rand}", "1.2.3.4")
		result.should be_successful
		result.errors.should be_empty
	end

	it "should fetch a purchase" do
		result = @gw.purchase(10000, {:card_holder => "Matthew Savage", :number => "5123456789012346", :expiry => "05/2013", :cvv => 123}, "TES#{rand}T", "1.2.3.4")
		puts "ID: " + result.purchase.id
		purchase = @gw.purchases(:id => result.purchase.id)

		purchase.id = result.purchase.id
	end
end