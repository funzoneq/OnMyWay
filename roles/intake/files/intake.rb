#!/usr/bin/env ruby

require 'collins_auth'

client = Collins::Authenticator.setup_client

tag  = `/usr/sbin/dmidecode -s system-serial-number`
lshw = File.read('/tmp/it-lshw-report.xml')
lldp = File.read('/tmp/it-lldp-report.xml')

# http://tumblr.github.io/collins/api.html#api-asset-get-section
asset = client.get(tag, { :details => true })
newasset = false

if not client.exists?(tag)
  # Create the asset in collins
  # http://tumblr.github.io/collins/api.html#api-asset-create-section
  asset = client.create!(tag, {:generate_ipmi => true, :type => "SERVER_NODE" })
  newasset = true
end

if newasset or asset.get_attribute("reintake") == 'true'
  # Post lshw and lldp information
  # http://tumblr.github.io/collins/api.html#api-asset-update-section
  client.set_multi_attribute!(tag, { "lldp" => lldp, "lshw" => lshw, "CHASSIS_TAG" => tag })
end

# Create a lock file so that we don't re-intake
File.open("/var/db/intake.lock", 'w+') {|f| f.write("Remove me if you want to re-intake.") }