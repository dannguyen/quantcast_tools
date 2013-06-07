require 'spec_helper'
include QuantcastTools

describe QuantcastTools::PageReader do 

   context "edge cases involving pages that don't exist or are hidden", :skip => true do 

      # Quantcast will seem to have info for non-existent pages
      context "nonexistent example that is not-networked" do
         before(:each) do 
            @q_reader = PageReader.new "http://www.unavailablezexample.com"
            @q_reader.fetch_from_qc!
         end 

         it "should not be hidden?" do 
            expect( @q_reader.hidden? ).to be_false
         end

         it "should not be quantified?" do 
            expect( @q_reader.quantified? ).to be_false
         end

         it "should not have enough_info?" do 
            expect( @q_reader.enough_info?).to be_false
         end

         it "should have nil for :rank_us" do 
            expect( @q_reader.rank_us ).to be_nil
         end

         it "should have nil for :monthly_unique_visitors_us" do 
            expect( @q_reader.monthly_unique_visitors_us ).to be_nil
         end
      end




      # Quantcast will seem to have info for non-existent subdomains
      context "unquantified example and non-existent", :skip => true do
         before(:each) do 
            @q_reader = PageReader.new "http://notarealsitebuthasanetwork.tumblr.com"
            @q_reader.fetch_from_qc!
         end 

         it "should not be quantified?" do 
            expect( @q_reader.quantified? ).to be_false
         end

         it "should not have enough_info?" do 
            expect( @q_reader.enough_info? ).to be_true
         end

         it "should still be networked?" do 
             expect( @q_reader.networked? ).to be_true
         end

         it "should still have network_name" do 
             expect( @q_reader.network_name ).to eq "Tumblr Blog Network"
         end


         it "should have nil for :rank_us" do 
            expect( @q_reader.rank_us ).to be_nil
         end
      end



      context "quantified example with hidden by owner request", :skip => true do 
         before(:each) do 
            @q_reader = PageReader.new "http://bubblews.com"
            @q_reader.fetch_from_qc!
         end 

         it "should be hidden?" do 
            expect( @q_reader.hidden? ).to be_true
         end

         it "should be quantified?" do 
            expect( @q_reader.quantified? ).to be_true
         end

         it "should ... have enough_info?" do 
            # unimplemented...technically, there is enough info, we just can't see it
         end

         it "should have nil for :rank_us" do 
            expect( @q_reader.rank_us ).to be_nil
         end
      end

   end
end
