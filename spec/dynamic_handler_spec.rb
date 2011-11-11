# encoding: utf-8
require 'spec_helper'

describe Workbench::DynamicHandler do

  before do
    root = File.dirname(__FILE__) + '/fixtures/project'
    @server = Workbench::DynamicHandler.new root
  end

  it '/data.js => /data.js if exists' do
    @server.instance_eval {
      resolve_file('/data.js').should == '/data.js'
    }
  end

  it '/index.html => /index.html if exists' do
    @server.instance_eval {
      resolve_file('/index.html').should == '/index.html'
    }
  end

  it '/ => /index.haml' do
    @server.instance_eval {
      resolve_file('/').should == '/index.haml'
    }
  end

  it '/index => /index.haml' do
    @server.instance_eval {
      resolve_file('/index').should == '/index.haml'
    }
  end

  it '/test.html => /test.haml if file not exists' do
    @server.instance_eval {
      resolve_file('/test.html').should == '/test.haml'
    }
  end

  it '/index.htm => /index.haml' do
    @server.instance_eval {
      resolve_file('/index.htm').should == '/index.haml'
    }
  end

end
