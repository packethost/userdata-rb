require 'spec_helper'

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
  let(:json) do
    <<-JSON.strip
      { "some_key": "some_value" }
    JSON
  end
  let(:invalid) { 'This is not valid userdata' }
  subject { CloudInit::Userdata.new(userdata) }

  describe '#script?' do
    context 'with a script' do
      let(:userdata) { script }
      it { is_expected.to be_a_script }
    end

    context 'with a non-script' do
      let(:userdata) { cloud_config }
      it { is_expected.not_to be_a_script }
    end
  end

  describe '#cloud_config?' do
    context 'with cloud config' do
      let(:userdata) { cloud_config }
      it { is_expected.to be_cloud_config }
    end

    context 'with non-cloud config' do
      let(:userdata) { script }
      it { is_expected.not_to be_cloud_config }
    end
  end

  describe '#json?' do
    context 'with JSON' do
      let(:userdata) { json }
      it { is_expected.to be_json }
    end

    context 'with non-JSON' do
      let(:userdata) { cloud_config }
      it { is_expected.not_to be_json }
    end
  end

  describe '#valid?' do
    context 'valid script' do
      let(:userdata) { script }
      it { is_expected.to be_valid }
    end

    context 'valid cloud config' do
      let(:userdata) { cloud_config }
      it { is_expected.to be_valid }
    end

    context 'valid JSON' do
      let(:userdata) { json }
      it { is_expected.to be_valid }
    end

    context 'invalid userdata' do
      let(:userdata) { invalid }
      it { is_expected.not_to be_valid }
    end
  end
end
