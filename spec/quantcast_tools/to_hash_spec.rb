require 'spec_helper'
include QuantcastTools

describe QuantcastTools do 

   before(:each) do 
      @url = "http://www.example.com"
      @q_reader = PageReader.new(@url)
   end

   it 'should have #to_hash return a Hashie::Mash' do 
      @q_reader.fetch_from_qc!
      expect(@q_reader.to_hash).to be_a Hashie::Mash
   end
end


describe QuantcastTools::Ranker do 
   context "end-to-end class method" do 
      it 'should return a Hashie::Mash' do 
        expect( QuantcastTools::Ranker("http://www.example.com") ).to be_a Hashie::Mash
      end

      it 'should return expected values in convenience method' do 
         msh = QuantcastTools::Ranker("http://www.example.com")
         expect(msh.monthly_unique_visitors_us).to eq 30300
         expect(msh.rank_us ).to eq 43992
         expect(msh.qc_url ).to eq 'https://www.quantcast.com/www.example.com'
      end
   end
end
