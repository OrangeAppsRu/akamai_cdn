Puppet::Type.newtype(:akamai_property) do
  @doc = 'backup_ssh'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'name'
  end

  newparam(:cpcode) do
    desc 'cpcode'
    newvalues(/.+/)
  end

  newparam(:origin_hostname) do
    desc 'origin_hostname'
    newvalues(/.+/)
  end
  #
  # newparam(:private_key_path) do
  #   desc 'public_key_path'
  #   newvalues(/.+/)
  #   defaultto '/root/.ssh/id_rsa'
  # end
  #
  # newparam(:fact_file) do
  #   desc 'fact_file'
  #   defaultto 'backup.yaml'
  # end

  def generate
  end
end