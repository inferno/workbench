# encoding: utf-8
require 'spec_helper'

describe Workbench::HamlRenderer do

  before do
    @root = File.dirname(__FILE__) + '/fixtures'
  end

  it 'HAML файл' do
    result = Workbench::HamlRenderer.render "#{@root}/index.haml"
    result.should == "<h1 style=\"color: red\" title=\"&amp;\">Hello world!</h1>\n"
  end

  it 'файл с опциями' do
    result = Workbench::HamlRenderer.render "#{@root}/index.haml", { :attr_wrapper => "'", :escape_attrs => false }
    result.should == "<h1 style='color: red' title='&'>Hello world!</h1>\n"
  end

end
