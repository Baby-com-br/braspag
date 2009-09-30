require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Braspag
  describe "Cryptography" do
    before do
      @cryptography = Braspag::Cryptography.new BASE_URL, MERCHANT_ID
      @plain_text = "nome=ricardo"
      @encripted_text = "RblletYGBHp6oH9Y/bu8Mg=="
    end

    it "should encrypt request" do
      result = @cryptography.encrypt_request!(@plain_text)
      result.should == @encripted_text
    end

    it "should decrypt request" do
      pending
      result = @cryptography.decrypt_request!(@encripted_text)
      result.should == @plain_text
    end
  end
end
