require 'cgi'

module SpecFixtures

   PAGES_DIR = File.join File.dirname(__FILE__), 'pages'
   PAGES_CONTENT = {}

   extend self 

   def html(url_str)
      url = url_str.sub(/^.+?\/\//, '') # strips https://
      escaped_url_fname = CGI.escape( url ) + ".html"       
      return PAGES_CONTENT[url] ||= open(File.join(PAGES_DIR, escaped_url_fname ), "r"){|f| f.read }
   end


   def list_pages
      Dir.glob(File.join PAGES_DIR, ("*.html")).map{ |fname| 
         base_uri = CGI.unescape(fname.split("spec/fixtures/pages/")[1].chomp('.html'))

         [ base_uri, fname] 
      }
   end   


end