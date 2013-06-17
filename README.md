# QuantcastReader

Some tools to interpret Quantcast resources

## Installation

Add this line to your application's Gemfile:

    gem 'quantcast_tools'



## Usage

      QuantcastTools::Ranker("http//example.com")

      => {
          "qc_url"=>"https://www.quantcast.com/www.example.com",
          "hidden?"=>false,
          "quantified?"=>false,
          "enough_info?"=>true,
          "networked?"=>false,
          "network_name"=>nil,
          "updated_timestamp_str"=>"2013-06-01",
          "next_update_timestamp_str"=>"2013-07-01",
          "monthly_unique_visitors_us"=>45000,
          "rank_us"=>28963
      }
