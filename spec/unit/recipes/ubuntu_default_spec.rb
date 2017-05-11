#
# Cookbook:: mongodb
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mongodb::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04',
                                 step_into: ['mongodb_instance']) do |node|
        node.override['mongodb']['instances'] = {
          mongod1: {
            state: 'create',
          },
        }
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'adds the expected mongodb repository' do
      expect(chef_run).to add_apt_repository('mongodb').with(
        uri: 'http://repo.mongodb.org/apt/ubuntu',
        keyserver: 'hkp://keyserver.ubuntu.com:80',
        distribution: 'xenial/mongodb-org/3.4',
        components: ['multiverse'],
        key: 'EA312927'
      )
    end

    it 'installs the mongodb package' do
      expect(chef_run).to install_package('mongodb')
    end

    it 'creates the db directory' do
      expect(chef_run).to create_directory('/var/lib/mongo_mongod1')
    end

    it 'creates the pid directory' do
      expect(chef_run).to create_directory('/var/run/mongodb')
    end

    it 'creates the log directory' do
      expect(chef_run).to create_directory('/var/log/mongodb')
    end

    it 'creates the mongodb config file' do
      expect(chef_run).to create_template('/etc/mongod_mongod1.conf')
    end

    it 'creates the mongodb init file' do
      expect(chef_run).to create_template('/etc/init.d/mongod_mongod1')
    end
  end
end
