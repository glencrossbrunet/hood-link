require 'httparty'
require 'multi_json'

# Protocol (json message)
#
# vertical:
#   sash_height:
#     today: ##
#     average: ##
#     organization_best: ##
# horizontal:
#   sash_height:
#     average: ##.##
#     organization_best: ##.##

module DeviceCloud
	module Connect
		
		# auth: (hash)
		#   username: 'user-name-here'
		#   password: 'password-here'
		attr_accessor :auth		
	
		def headers
			{ 'Content-Type' => 'text/xml' }
		end
		
		def rci_request(device_id, message)
			<<-XML
	    <rci_request version="1.1">
	      <do_command target="xig">
					<send_data hw_address="#{device_id}">#{message}</send_data>
	      </do_command>
	    </rci_request>
			XML
		end
		
		def sci_request(server_id)
			<<-XML
			<sci_request version="1.0">
			  <send_message>
			    <targets>
			      <device id="#{server_id}"/>
			    </targets>
			    #{yield}
			  </send_message>
			</sci_request>
			XML
		end
	end
	
	class Client
		include Connect
				
		def initialize(auth = nil)
			self.auth = {	username: 'glencrossbrunet', password: 'GlenBrown2!' }
		end

		# fume hoods have a "display_id" of:
		#    "server_id | device_id"
		def update_display_for(fume_hood)
			server_id, device_id = fume_hood.data[:display_id].split(' | ')
			message = display_message_from(fume_hood)
						
			http_options = { 
				basic_auth: auth, 
				headers: headers,
				body: body_xml(server_id, device_id, message)
			}
			
			puts http_options
			
			response = HTTParty.post('http://login.etherios.com/ws/sci', http_options)
			p response.code, response.headers, response.body
			nil
		end
    
    # TODO: this is a stub
    def display_message_from(fume_hood)
      # Example message (pad with spaces):
      # `U 5";M10";L 3";`
    end
		
		def body_xml(server_id, device_id, message)
			sci_request(server_id) do
				rci_request(device_id, message)
			end
		end
	end
	
	
end