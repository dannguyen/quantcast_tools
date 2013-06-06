require "open-uri"
require "nokogiri"

module QuantcastTools
   class PageReader
      BASE_QUANTCAST_SERVICE_URL = "https://www.quantcast.com"

      attr_reader :url, :qc_url, :qc_html, :fetched_at_timestamp, :errors

      def initialize(the_url, opts={})
         @url = the_url 
         @qc_url = make_qc_url( @url )     
      end


      # expects: @qc_url to be set 
      # modifies: @fetched_at_timestamp, @qc_html
      def fetch_from_qc!      
         @fetched_at_timestamp = Time.now
         @qc_html = fetch_page(@qc_url)
         @errors = nil 
      end


      def fetched?
         !(@fetched_at_timestamp.nil?)
      end

      def has_errors?
         !(errors.nil?)
      end



      # >>>>>>> Quantcast characteristics
      # TODO 


      def hidden?
      end

      def quantified?
      end

      def enough_info?
      end

      def networked?
         !(network_name.nil?) && !(network_name.empty?)
      end


      # parsed from page
      def network_name
      end




      # >>>>>> Metrics
      # These methods use the :parsed_qc_html to get the appropriate value

      # TODO 
      def rank_us 

      end

      # TODO
      def monthly_unique_visitors_us

      end





      # >>>>> updated_at timestamps

      # matches MMM DD, YYYY
      # returns String, eg. "Feb 2013"

      def updated_timestamp_words
         if ts = parsed_traffic_table_text.match(/Updated (\w{3}(?: \d{1,2},)? \d{4})/)
            return ts[1]
         end
      end

      # returns String, eg. "Feb 2013"
      def next_update_timestamp_words
         if ts = parsed_traffic_table_text.match(/Next: (\w{3}(?: \d{1,2},)? \d{4})/)
            return ts[1]
         end   
      end


      # returns String, eg. "2013-02-01", even if timestamp_words is "Feb 01, 2013"
      def updated_timestamp_str
         Time.parse(updated_timestamp_words).strftime("%Y-%m-%d") unless updated_timestamp_words.nil?
      end

      # returns String, eg. "2013-02"
      def next_update_timestamp_str
         Time.parse(next_update_timestamp_words).strftime("%Y-%m-%d") unless next_update_timestamp_words.nil?
      end


      # >>>>>>>>>>>>> Private

      private

      # opens a page and read its contents
      # returns: a String
      def fetch_page(url)
         open(url){|f| f.read }
      end

      def make_qc_url(url)
         target_path = URI.parse(url).to_s.split("//")[1]
         return URI.join( BASE_QUANTCAST_SERVICE_URL, target_path).to_s
      end


      # Parses the raw HTML in @qc_html as a Nokogiri object and memoizes the result
      # returns: Nokogiri::HTML
      def parsed_qc_html
         if fetched?
            @_pqc ||= Nokogiri::HTML( @qc_html )
         end
      end

      # convienence method since both updated_at and next_update text is in the same element
      # returns: a String
      def parsed_traffic_table_text
         parsed_qc_html.css('#traffic-table-vintage small.vintage')[0].text.squeeze("\s").strip
      end

   end

end
