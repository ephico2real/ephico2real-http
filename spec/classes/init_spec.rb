require 'spec_helper'
describe 'http' do

  context 'with defaults for all parameters' do
    it { should contain_class('http') }
  end
end
