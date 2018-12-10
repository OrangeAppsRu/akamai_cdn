require 'akamai/edgegrid'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'

class Puppet::Provider::Akamai < Puppet::Provider
  @test = 'sdvdsvsdv'

  def self.product_id
    'prd_Download_Delivery'
  end

  def auth(credentails)
    @credentails = credentails
    @baseuri = URI(credentails['baseuri'])
    @http = ::Akamai::Edgegrid::HTTP.new(
        address = @baseuri.host,
        port = @baseuri.port
    )

    @http.setup_edgegrid(
        :client_token  => credentails['client_token'],
        :client_secret => credentails['client_secret'],
        :access_token  => credentails['access_token'],
        :max_body      => 128 * 1024
    )
  end

  def create_cpcode(cpcode)
    cpcodes = get_cpcodes(cpcode)
    if cpcodes.length > 0
      cpcode = cpcodes[0]['cpcodeId']
    else
      #if cpcode not exists, create it
      post_request = Net::HTTP::Post.new(
          URI.join(@baseuri.to_s, "/papi/v1/cpcodes?contractId=#{@credentails['contract_id']}&groupId=#{@credentails['group_id']}").to_s,
          initheader = { 'Content-Type' => 'application/json' }
      )

      post_request.body = {
          'productId'  => self.class.product_id,
          'cpcodeName' => cpcode,
      }.to_json

      @http.request(post_request)
      cpcodes = get_cpcodes(cpcode)
      cpcode = cpcodes[0]['cpcodeId']
    end
    cpcode
  end

  def get_cpcodes(cpcode)
    # check exists cpcode
    request = Net::HTTP::Get.new URI.join(@baseuri.to_s, "/papi/v1/cpcodes?contractId=#{@credentails['contract_id']}&groupId=#{@credentails['group_id']}").to_s
    response = @http.request(request)
    cpcodes = JSON.parse(response.body)['cpcodes']['items']
    cpcodes = cpcodes.map do |el|
      if el['cpcodeName'] == cpcode
        el
      end
    end
    return cpcodes.compact
  end

end

Puppet::Type.type(:akamai_property).provide(:akamai_property, parent: Puppet::Provider::Akamai) do
  desc 'provider akamai_property'

  def exists?
    Puppet.notice('akamai_property exists?')
    credentails = YAML.load(File.read('/root/.akamai/credentails'))
    cpcode = @resource['cpcode']

    # auth in akamai
    # Create @http object for reqiests to akamai api
    auth(credentails)
    @resource['cpcode'] = create_cpcode(cpcode)
    puts "CPCODE = #{@resource['cpcode']}"


  end

  def create
    Puppet.notice('akamai_property create')
  end


  def destroy
    Puppet.notice('akamai_property destoy')
  end
end