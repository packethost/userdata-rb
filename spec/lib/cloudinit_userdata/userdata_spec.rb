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
  let(:power_shell) do
    <<-POWER_SHELL.strip
      #ps1

      Write-Host "Hello, World!"
    POWER_SHELL
  end
  let(:power_shell_x_86) do
    <<-POWER_SHELL_X_86.strip
      #ps1_x86

      Write-Host "Hello, World!"
    POWER_SHELL_X_86
  end
  let(:jinja_template) do
    <<~JINJA_TEMPLATE
      ## template: jinja
      #cloud-config
      puppet:
      conf:
        agent:
          server: "puppetmaster.local"
          certname: "{{ v1.instance_id }}.%f"
    JINJA_TEMPLATE
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
      power_shell: CloudInit::Userdata::PowerShell,
      power_shell_x_86: CloudInit::Userdata::PowerShell,
      jinja_template: CloudInit::Userdata::JinjaTemplate,
      blank: CloudInit::Userdata::Blank,
      nil: CloudInit::Userdata::Blank
    }.each_pair do |value, klass|
      context "with valid userdata (#{klass})" do
        let(:userdata) { send(value) }
        it { is_expected.to be_a(klass) }
      end
      context "with userdata validated (#{klass})" do
        let(:userdata) { send(value) }
        it { expect(subject.valid?).to be_truthy }
      end
    end

    context 'with invalid userdata' do
      let(:userdata) { invalid }
      it { expect { subject }.to raise_error(CloudInit::Userdata::InvalidFormat) }
    end
  end
end
