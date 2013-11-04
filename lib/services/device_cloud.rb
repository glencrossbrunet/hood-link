require 'httparty'

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
    
    def send_message(server_id, device_id, message)
			xml = sci_request(server_id) do
				rci_request(device_id, message)
			end
      
			http_options = { 
				basic_auth: auth, 
				headers: headers,
				body: xml
			}
      
      response = HTTParty.post(endpoint, http_options)      
      raise "FAILED: #{response.code}" unless (200...300).include? response.code
    end
    
    def endpoint
      'http://login.etherios.com/ws/sci'
    end
	end
	
	class Client
		include Connect
				
		def initialize
			self.auth = {	username: 'glencrossbrunet', password: 'GlenBrown2!' }
		end
	end
end