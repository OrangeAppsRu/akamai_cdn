# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include akamai_cdn
class akamai_cdn (
    String $contract_id,
    String $group_id,
    String $client_token,
    String $access_token,
    String $client_secret,
    String $baseuri,
    Hash $properties = {},
) {
    $credentails_file = {
        'contract_id'   => $contract_id,
        'group_id'      => $group_id,
        'client_token'  => $client_token,
        'access_token'  => $access_token,
        'client_secret' => $client_secret,
        'baseuri'       => $baseuri,
    }
    file {'/root/.akamai':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
    } ->

    file {'/root/.akamai/credentails':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => to_yaml($credentails_file)
    }

    package {'akamai-edgegrid':
        ensure   => '1.0.6',
        provider => 'puppet_gem'
    }

    create_resources('akamai_property', $properties)
}
