# encoding: utf-8
require 'spec_helper'

describe 'SASS and Compass' do

  before do
    @root = File.dirname(__FILE__) + '/fixtures'
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Workbench::Application.new(File.join(@root, 'project')).app))
  end

  it 'работает SASS' do
  end

  it 'работает Compass' do
  end

end
