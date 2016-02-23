require 'spec_helper'
require 'zlib'
require 'stringio'
require 'pp'

RSpec.describe CloudInit::Userdata do
  let(:userdata) { nil }
  let(:script) do
    <<-SCRIPT.strip
      #!/bin/bash

      echo "Hello!"
    SCRIPT
  end
  let(:cloud_config) do
    <<-CLOUD_CONFIG.strip
      #cloud-config

      some_key: some_value
    CLOUD_CONFIG
  end
  let(:cloud_boothook) do
    <<-CLOUD_BOOTHOOK.strip
      #cloud-boothook

      Some cloud boothook stuff.
    CLOUD_BOOTHOOK
  end
  let(:gzipped) do
    output = StringIO.new
    output.set_encoding 'BINARY'
    gz = Zlib::GzipWriter.new(output, Zlib::DEFAULT_COMPRESSION, Zlib::DEFAULT_STRATEGY)
    gz.write(script)
    gz.close
    output.rewind
    output.string
  end
  let(:mime_multipart) do
    <<-MIME.strip
      From nobody Tue Feb 23 00:00:00 2016
      Content-Type: multipart/mixed; boundary="===============7512168895100174639=="
      MIME-Version: 1.0

      --===============7512168895100174639==
      MIME-Version: 1.0
      Content-Type: text/x-shellscript; charset="us-ascii"
      Content-Transfer-Encoding: 7bit
      Content-Disposition: attachment; filename="script.sh"

      #!/bin//bash

      echo "Hello!!!"

      --===============7512168895100174639==
      MIME-Version: 1.0
      Content-Type: text/cloud-boothook; charset="us-ascii"
      Content-Transfer-Encoding: 7bit
      Content-Disposition: attachment; filename="cloud_boothook.txt"

      Hello!!!

      --===============7512168895100174639==--
    MIME
  end
  let(:blank) { '' }
  let(:nil) { nil }
  let(:invalid) { 'This is not valid userdata' }
  subject { CloudInit::Userdata.parse(userdata) }

  describe '.parse' do
    {
      script: CloudInit::Userdata::ShellScript,
      cloud_config: CloudInit::Userdata::CloudConfig,
      cloud_boothook: CloudInit::Userdata::CloudBoothook,
      gzipped: CloudInit::Userdata::Gzipped,
      mime_multipart: CloudInit::Userdata::MimeMultipart,
      blank: CloudInit::Userdata::Blank,
      nil: CloudInit::Userdata::Blank
    }.each_pair do |value, klass|
      context "with valid userdata (#{klass})" do
        let(:userdata) { send(value) }
        it { is_expected.to be_a(klass) }
      end
    end

    context 'with invalid userdata' do
      let(:userdata) { invalid }
      it { expect { subject }.to raise_error(CloudInit::Userdata::InvalidFormat) }
    end
  end
end
