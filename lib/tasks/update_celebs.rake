require 'open-uri'
require 'json'
require 'digest/md5'

namespace :update_celebs do

  task :populate_urls => :environment do
    baseUrl = "http://www.celebheights.com"

    pages = [
        baseUrl + '/s/A.html',
        baseUrl + '/s/B.html',
        baseUrl + '/s/C.html',
        baseUrl + '/s/D.html',
        baseUrl + '/s/E.html',
        baseUrl + '/s/F.html',
        baseUrl + '/s/G.html',
        baseUrl + '/s/H.html',
        baseUrl + '/s/I.html',
        baseUrl + '/s/J.html',
        baseUrl + '/s/K.html',
        baseUrl + '/s/L.html',
        baseUrl + '/s/M.html',
        baseUrl + '/s/N.html',
        baseUrl + '/s/O.html',
        baseUrl + '/s/P.html',
        baseUrl + '/s/Q.html',
        baseUrl + '/s/R.html',
        baseUrl + '/s/S.html',
        baseUrl + '/s/T.html',
        baseUrl + '/s/U.html',
        baseUrl + '/s/V.html',
        baseUrl + '/s/W.html',
        baseUrl + '/s/X.html',
        baseUrl + '/s/Y.html',
        baseUrl + '/s/Z.html',
    ]

    pages.each do |url|

      s = Scan.find_or_create_by_url((url))

      s.last_scan =  DateTime.now-1.year

      s.save

    end
  end

  task :update_heights => :environment do
    @colleciton = Scan.all

    @colleciton.each do |s|

      # Get the doc either from site or cache
=begin
      if s.last_scan+14.days  < DateTime.now
        doc = Nokogiri::HTML(open(s.url))
        s.html = doc.to_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "")
        s.last_scan = DateTime.now
        s.save
      else
        doc = Nokogiri::HTML(s.html)
      end
=end
      doc = Nokogiri::HTML(s.html)

      # Get all elements we want to scan
      @elements = doc.css('div.starazCol.v11')

      # Loop elements
      @elements.each do |item|

        if item.css('a.v11').text.blank? == false
          # Get Full Name from item
          fullName = item.css('a.v11').text.strip

          nameArray = fullName.split(' ')

          firstName = nameArray[0]

          lastName = nameArray.last

          ftHeight = item.text.strip.match(/\(.*?\)/)[0]

          Rails.logger.debug("My object: #{ftHeight.inspect}")

          feet = ftHeight.split('ft')[0].gsub(/\s+/, '').gsub('(', '')

          inches = ftHeight.split('ft')[1].gsub('in', '').gsub(')', '').gsub(/\s+/, '')

          metricHeight = (feet.to_f * 0.3048) + (inches.to_f * 0.0254)

          c = Celeb.find_or_initialize_by_full_name(fullName)

          c.first_name = firstName
          c.last_name = lastName
          c.metric_height = metricHeight

          c.save
        end

      end

    end
  end

  task :resave_all => :environment do
    Celeb.find_each(&:save)
  end

  task :update_meta => :environment do

    @celebs = Celeb.where("scanned is false")

    @celebs.each do |celeb|

      c = Celeb.find_by_full_name(celeb.full_name)

      # DETERMINE A SEARCH NAME

      search_name = celeb.full_name

      if !celeb.wiki_name.blank?
        search_name = celeb.wiki_name
      end

      # DESCRIPTIONS

      xml_object = open(URI.parse("http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString="+URI::encode(search_name)+"&MaxHits=1")).read

      doc = Nokogiri::XML(xml_object)

      description = doc.css("Description").text.strip

      #match(/([^.!?]|(?<=etc|Dr|Mr|Mrs|Jr)[.!?])+/)[0].to_s + '.'

      if description.blank? == false
        c.description = description
      end

      # Rails.logger.debug("My object: #{celeb.avatar_present?}")

      # FIND IMAGE

      json_object = JSON.parse(open(URI.parse("http://en.wikipedia.org/w/api.php?format=json&action=query&titles="+URI::encode(search_name)+"&prop=pageimages&pithumbsize=300")).read)
      page_object = json_object['query']['pages']
      #Rails.logger.debug("My object: #{json_object}")
      #Rails.logger.debug("My object: #{page_object.first.first}")
      if page_object.first.first.blank? == false && page_object[page_object.first.first]['thumbnail'].blank? == false

        # Get image url
        img_url = page_object[page_object.first.first]['thumbnail']['source']

        c.remote_avatar_url = img_url

      end

      c.scanned = true
      c.save!

    end
  end
end
