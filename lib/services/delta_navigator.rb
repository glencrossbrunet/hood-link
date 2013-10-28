# coding: utf-8
require 'httparty'

class DeltaNavigator
  module LookupTable
    def lookup_table
      @lookup_table ||= {
        "22361"=>"mcintyre-108-1", "22370"=>"mcintyre-110-1", "22371"=>"mcintyre-115-1", 
        "22372"=>"mcintyre-115-2", "22373"=>"mcintyre-116-1", "22374"=>"mcintyre-119-1",
        "22362"=>"mcintyre-133-1", "22351"=>"mcintyre-1303-1", "22331"=>"mcintyre-1307-1", 
        "22346"=>"mcintyre-1309-1", "22364"=>"mcintyre-1311-1", "22328"=>"mcintyre-1312-1", 
        "22350"=>"mcintyre-1313-1", "22349"=>"mcintyre-1314-1", "22363"=>"mcintyre-1315-1", 
        "22334"=>"mcintyre-1317-1", "22365"=>"mcintyre-1320-1", "22366"=>"mcintyre-1321-1", 
        "22376"=>"mcintyre-705-1", "22360"=>"mcintyre-706-1", "22377"=>"mcintyre-707-1", 
        "22378"=>"mcintyre-708-1", "22367"=>"mcintyre-710-1", "22369"=>"mcintyre-712-1", 
        "22379"=>"mcintyre-713-1", "22275"=>"mcintyre-800-1", "22276"=>"mcintyre-800-2", 
        "22281"=>"mcintyre-805-1", "22286"=>"mcintyre-810-1", "22287"=>"mcintyre-810-2", 
        "22295"=>"mcintyre-815-1", "22296"=>"mcintyre-815-2", "22291"=>"mcintyre-825-1", 
        "22261"=>"mcintyre-900-1", "22262"=>"mcintyre-900-2", "22250"=>"mcintyre-915-1", 
        "22243"=>"mcintyre-910-1", "22245"=>"mcintyre-910-2", "22247"=>"mcintyre-910A-1", 
        "22256"=>"mcintyre-930-1", "22266"=>"mcintyre-944-1", "22348"=>"mcintyre-1002-1", 
        "22347"=>"mcintyre-1003-1", "22352"=>"mcintyre-1008-1", "22315"=>"mcintyre-1012-1", 
        "22388"=>"mcintyre-1106-1", "22355"=>"mcintyre-1114-1", "22384"=>"mcintyre-1115-1", 
        "22383"=>"mcintyre-1119-1", "22391"=>"mcintyre-1122-1", "22353"=>"mcintyre-1126-1", 
        "22354"=>"mcintyre-1129-1", "22375"=>"mcintyre-1131-1", "22356"=>"mcintyre-1205-1", 
        "22358"=>"mcintyre-1207-1", "22359"=>"mcintyre-1212-1", "22381"=>"mcintyre-1213-1", 
        "22341"=>"mcintyre-1217-1", "22382"=>"mcintyre-1218-1", "22394"=>"mcintyre-1218-2", 
        "22389"=>"mcintyre-1220A-1", "22390"=>"mcintyre-1221-1", "22385"=>"mcintyre-1227-1", 
        "22392"=>"mcintyre-1227-2", "22386"=>"mcintyre-1230-1", "22393"=>"mcintyre-1239-1", 
        "22380"=>"mcintyre-1240-1", "22387"=>"mcintyre-1253-1", "22357"=>"mcintyre-1254-1"
      }
    end
        
    def external_id_from(bac_number)
      (lookup_table || {})[bac_number]
    end
  end
  
  module Parser
    def url
      'http://mcgill.hoodlink.ca/samples.json'
    end

    def organization_token
      'Oe0MdXp4Q2w4uAufbsSNvivjpWIZs2nOFlLWw5CVGmE'
    end

    def organization_json
      { organization: { token: organization_token } }
    end

    def external_id_from(bac_number)
      self.class.external_id_from(bac_number)
    end

    def fume_hood_json(bac_number)
      puts bac_number
      { fume_hood: { external_id: external_id_from(bac_number) } }
    end

    def sample_metric_json(metric_name)
      { sample_metric: { name: metric_name } }
    end

    def json_body(bac_number, unix_time, metric_name, value, unit)
      json = {
        sample: {
          sampled_at: DateTime.strptime(unix_time,'%s').to_s,
          value: value.to_f,
          unit: unit,
          source: 'Delta Web Navigator'
        }
      }
      json.merge! organization_json
      json.merge! fume_hood_json(bac_number)
      json.merge! sample_metric_json(metric_name)
      json
    end

    # 1382591547, 22328, NA, NA
    # 1382591547, 22350, 282 l/s, 73.549995 %
    def save_samples(text_line)
      values = text_line.split(',').map(&:strip)
      unix_time, bac_number, flow_rate, percent_open = values
      
      if percent_open != 'NA'
        json = json_body(bac_number, unix_time, 'Percent Open', *percent_open.split(' ')) 
        response = HTTParty.post url, body: json
        puts "status: #{response.code}"
        puts "body: #{response.body}"
      end
    end
  end
  
  extend Parser
  extend LookupTable
end