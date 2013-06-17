require "hashie"

module QuantcastTools

   class << self
      #returns Hash::Mashie
      def Ranker(url)
         q = QuantcastTools::PageReader.new(url)
         q.fetch_from_qc!
         return q.to_hash
      end
   end

   module Ranker
      class << self; end 
   end

end

require "quantcast_tools/version"
require "quantcast_tools/page_reader"

