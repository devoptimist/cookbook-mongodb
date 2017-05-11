# # encoding: utf-8

# Inspec test for recipe mongodb::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

if os.redhat?
  describe user('mongod') do
    it { should exist }
  end
elsif os.debian?
  describe user('mongodb') do
    it { should exist }
  end
end

describe service('mongod_testdb1') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(27017) do
  it { should be_listening }
end
