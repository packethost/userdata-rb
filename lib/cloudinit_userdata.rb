$LOAD_PATH.unshift File.dirname(__FILE__)

require 'cloudinit_userdata/version'
require 'cloudinit_userdata/errors'
require 'cloudinit_userdata/userdata'

module CloudInit
end

#
# Register our userdata formats.
#

# Note that the Gzipped formatter should go first so that it can deal with
# binary data.
require 'cloudinit_userdata/formats/gzipped'
CloudInit::Userdata.register_format(CloudInit::Userdata::Gzipped)

require 'cloudinit_userdata/formats/blank'
CloudInit::Userdata.register_format(CloudInit::Userdata::Blank)

require 'cloudinit_userdata/formats/cloud_boothook'
CloudInit::Userdata.register_format(CloudInit::Userdata::CloudBoothook)

require 'cloudinit_userdata/formats/cloud_config'
CloudInit::Userdata.register_format(CloudInit::Userdata::CloudConfig)

require 'cloudinit_userdata/formats/include'
CloudInit::Userdata.register_format(CloudInit::Userdata::Include)

require 'cloudinit_userdata/formats/mime_multipart'
CloudInit::Userdata.register_format(CloudInit::Userdata::MimeMultipart)

require 'cloudinit_userdata/formats/part_handler'
CloudInit::Userdata.register_format(CloudInit::Userdata::PartHandler)

require 'cloudinit_userdata/formats/power_shell'
CloudInit::Userdata.register_format(CloudInit::Userdata::PowerShell)

require 'cloudinit_userdata/formats/shell_script'
CloudInit::Userdata.register_format(CloudInit::Userdata::ShellScript)

require 'cloudinit_userdata/formats/upstart_job'
CloudInit::Userdata.register_format(CloudInit::Userdata::UpstartJob)
