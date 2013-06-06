require 'spec_helper'
include QuantcastTools

describe QuantcastTools::PageReader do 

   it "should just pass" do 
      expect(true).to eq true
   end


   context "initialization" do 
      it "should initialize with a page url as first parameter" do 
         @q_reader = PageReader.new("http://www.example.com")
         expect( @q_reader.url ).to eq "http://www.example.com"
      end

      it "should raise an ArgumentError when no argument is provided" do 
         expect{ @q_reader = PageReader.new }.to raise_error ArgumentError
      end

      it "should have corresponding :qc_url" do 
         @q_reader = PageReader.new "http://www.example.com"
         expect( @q_reader.qc_url ).to eq "https://www.quantcast.com/www.example.com"
      end

      it "should initially not be fetched?" do 
         @q_reader = PageReader.new "http://www.example.com"
         expect( @q_reader.fetched? ).to be_false
      end 

      it "should initially have no :qc_html" do 
         @q_reader = PageReader.new("http://www.example.com")
         expect( @q_reader.qc_html ).to be_nil
      end
   end


   context "page fetching" do
      before(:each) do 
         @url = "http://www.example.com"
         @q_reader = PageReader.new @url
         @q_reader.fetch_from_qc!
      end

      it "should be :fetched?" do 
         expect( @q_reader.fetched? ).to be_true
      end

      it "should :fetch_from_qc! and fill :qc_html with raw HTML from Quantcast Page" do 
         @q_reader.fetch_from_qc!
         expect( @q_reader.qc_html ).to eq SpecFixtures.html("www.quantcast.com/www.example.com")
      end 

      it "should record a :fetched_at_timestamp" do 
         @time_now = Time.now.to_i
         @q_reader.fetch_from_qc!
         expect( @q_reader.fetched_at_timestamp.to_i ).to be_within(2).of @time_now 
      end
   end





   describe "parsing of the QC page html" do 

      # A domain that does exist and has enough traffic, but not officially quantified
      context "typical example with example.com" do
         before(:each) do 
            @q_reader = PageReader.new("http://www.example.com")
            @q_reader.fetch_from_qc!
         end 

         # most sites aren't "Quantified"
         it "should not be quantified?" do 
            expect( @q_reader.quantified? ).to be_false
         end

         it "should have enough_info?" do 
            expect( @q_reader.enough_info?).to be_true
         end

         it "should not be hidden?" do 
            expect( @q_reader.hidden? ).to be_false
         end


         it "should not be networked?" do 
            expect( @q_reader.networked?).to be_false
         end

         it "should not have a network_name" do 
            expect( @q_reader.network_name).to be_nil
         end


         it "should get U.S. rank as Integer" do 
            expect( @q_reader.rank_us ).to eq 43992
         end

         it "should get :monthly_unique_visitors_us as Integer" do 
            expect( @q_reader.monthly_unique_visitors_us ).to eq 30337
         end


         context "updated_timestamp" do 
            it "should get :updated_timestamp_words" do 
               expect( @q_reader.updated_timestamp_words).to eq "May 2013"
            end

            it "should get :updated_timestamp_str" do 
               expect( @q_reader.updated_timestamp_str).to eq "2013-05-01"
            end

            it "should get :next_update_timestamp_words" do 
               expect( @q_reader.next_update_timestamp_words).to eq "Jun 2013"
            end

            it "should get :updated_timestamp_str" do 
               expect( @q_reader.next_update_timestamp_str).to eq "2013-06-01"
            end
         end
      end # end typical example



     ##########################
     # A domain that is quantified, has plenty of info, but is NOT networked

      context "quantified theverge.com" do
         before(:each) do 
            @q_reader = PageReader.new("http://theverge.com")
            @q_reader.fetch_from_qc!
         end 

         # most sites aren't "Quantified"
         it "should  be quantified?" do 
            expect( @q_reader.quantified? ).to be_true
         end

         it "should have enough_info?" do 
            expect( @q_reader.enough_info?).to be_true
         end

         it "should be networked?" do 
            expect( @q_reader.networked?).to be_false
         end

         it "should get U.S. rank as Integer" do 
            expect( @q_reader.rank_us ).to eq "TODO"
         end

         it "should get :monthly_unique_visitors_us as Integer" do 
            expect( @q_reader.monthly_unique_visitors_us ).to eq "TODO"
         end


         context "updated_timestamp" do 
            it "should get :updated_timestamp_words" do 
               expect( @q_reader.updated_timestamp_words).to eq "Jun 5, 2013"
            end

            it "should get :updated_timestamp_str" do 
               expect( @q_reader.updated_timestamp_str).to eq "2013-06-05"
            end

            it "should get :next_update_timestamp_words" do 
               expect( @q_reader.next_update_timestamp_words).to eq "Jun 6, 2013"
            end

            it "should get :updated_timestamp_str" do 
               expect( @q_reader.next_update_timestamp_str).to eq "2013-06-06"
            end
         end
      end 




     ##########################
     # A domain that is quantified, has plenty of info, and is networked

      context "quantified with plenty of info and is networked" do
         before(:each) do 
            @q_reader = PageReader.new("http://wordpress.com")
            @q_reader.fetch_from_qc!
         end 

         it "should be quantified?" do 
            expect( @q_reader.quantified? ).to be_true
         end
         
         it "should not be hidden?" do 
            expect( @q_reader.hidden? ).to be_false
         end

         it "should have enough_info?" do 
            expect( @q_reader.enough_info?).to be_true
         end

         it "should be networked?" do 
            expect( @q_reader.networked?).to be_true
         end

         it "should have a network_name" do 
            expect( @q_reader.network_name).to eq "Automattic Network"
         end

         it "should get U.S. rank as Integer" do 
            expect( @q_reader.rank_us ).to eq "TODO"
         end

         it "should get :monthly_unique_visitors_us as Integer" do 
            expect( @q_reader.monthly_unique_visitors_us ).to eq "TODO"
         end


      end 


      



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
      context "unquantified example and non-existent" do
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



      context "quantified example with hidden by owner request" do 

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