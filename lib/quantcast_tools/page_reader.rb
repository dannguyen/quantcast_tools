require "open-uri"
require "nokogiri"

module QuantcastTools
   class PageReader
      BASE_QUANTCAST_SERVICE_URL = "https://www.quantcast.com"

      attr_reader :url, :qc_url, :qc_html, :qc_canonical_url,
         :fetched_at_timestamp, :errors

      def initialize(the_url, opts={})
         @url = the_url 
         @qc_url = make_qc_url( @url )     
         # this URL seems to be used by quantcast in their internal system, independent of the 
         # URL passed into the parameter
         @qc_canonical_url = make_qc_canonical_url(@url)
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
         if parsed_qc_html.css("div.messaging.clearfix")
            if parsed_qc_html.css("div.messaging.clearfix").text.include? "data has been hidden by the owner."
               true
            end
         end
      end

      def quantified?
         if parsed_qc_html.css("li.badge.quantified h4").text == "Quantified"
            if parsed_qc_html.css("li.badge.quantified p.caption").text == "Rough Estimate"
               false
               # parsed_qc_html.css("li.badge.quantified p.caption").text
            else
               true
            end
         elsif parsed_qc_html.css("li.badge.unquantified h4").text == "Not Quantified"
            false
         end
      end

      def enough_info?
         true unless parsed_qc_html.css("div.summary p").text.include? "We do not have enough information to provide a traffic estimate"
      end

      def networked?
         !(network_name.nil?) && !(network_name.empty?)
      end


      # parsed from page
      def network_name
         if parsed_qc_html.css("tbody#wunit-hierarchy-table tr:not(.current) a").first
            parsed_qc_html.css("tbody#wunit-hierarchy-table tr:not(.current) a").first.text.strip
         end
      end




      # >>>>>> Metrics
      # These methods use the :parsed_qc_html to get the appropriate value

      # TODO
      def rank_us
         if enough_info?
            unless parsed_qc_html.css("li.rank span").text.empty?
               parsed_qc_html.css("li.rank span").text.gsub(',', '').to_i
            end
         end
      end

      # The text bit looks like this:
      # Monthly Uniques    67.4M US    291.1M Global
      #
      # returns: Integer, where M and K are translated to 1000000 and 1000, respectively
      def monthly_unique_visitors_us

         m_val = parsed_qc_html.css(".current").select{|c| c['profile-data'] == "-1"}[0].text.strip
         unless m_val.include? "N/A"
            #parse with regex, e.g. "3.2", "M"
            m_number, m_abbrev =  m_val.match(/(\d+\.\d+)([\w]?)/)[1..2]
            multiplier = case m_abbrev
            when 'K'
               1000
            when 'M'
               1000000
            when 'B'
               1000000000
            else
               1
            end

            return (m_number.to_f * multiplier).to_i
         end
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

      # takes in: "http://www.example.com"
      # returns: "https://www.quantcast.com/www.example.com"
      def make_qc_url(url)
         target_path = URI.parse(url).to_s.split("//")[1]
         return URI.join( BASE_QUANTCAST_SERVICE_URL, target_path).to_s
      end

      # takes in: "http://www.example.com"
      # returns: com.example
      def make_qc_canonical_url(url)
         target_path = URI.parse(url).to_s.split("//")[1]
         target_path.split('.').reverse.join('.').chomp('.www')
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
