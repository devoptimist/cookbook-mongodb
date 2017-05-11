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
            state: 'delete',
          },
        }
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'adds the expected mongodb repository' do
      expect(chef_run).to remove_apt_repository('mongodb')
    end

    it 'removes the mongodb package' do
      expect(chef_run).to remove_package('mongodb')
    end

    it 'removes the mongodb db directory' do
      expect(chef_run).to delete_directory('/var/lib/mongo')
    end

    it 'removes the pid directory' do
      expect(chef_run).to delete_directory('/var/run/mongodb')
    end

    it 'removes the mongodb log directory' do
      expect(chef_run).to delete_directory('/var/log/mongodb')
    end

    it 'removes the mongodb config file' do
      expect(chef_run).to delete_file('/etc/mongod_mongod1.conf')
    end

    it 'removes the mongodb init file' do
      expect(chef_run).to delete_file('/etc/init.d/mongod_mongod1')
    end
  end
end
