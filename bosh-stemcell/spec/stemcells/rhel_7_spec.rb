require 'spec_helper'

describe 'RHEL 7 stemcell', stemcell_image: true do

  it_behaves_like 'All Stemcells'
  it_behaves_like 'a CentOS 7 or RHEL 7 stemcell'
  it_behaves_like 'udf module is disabled'

  context 'installed by system_parameters' do
    describe file('/var/vcap/bosh/etc/operating_system') do
      its(:content) { should include('centos') }
    end
  end

  context 'installed by bosh_openstack_agent_settings', {
    exclude_on_aws: true,
    exclude_on_google: true,
    exclude_on_vcloud: true,
    exclude_on_vsphere: true,
    exclude_on_warden: true,
    exclude_on_azure: true,
  } do
    describe file('/var/vcap/bosh/agent.json') do
      it { should be_valid_json_file }
      its(:content) { should_not include('"CreatePartitionIfNoEphemeralDisk": true') }
      its(:content) { should include('"Type": "ConfigDrive"') }
      its(:content) { should include('"Type": "HTTP"') }
    end
  end
end
