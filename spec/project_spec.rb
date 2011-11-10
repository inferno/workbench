# encoding: utf-8

require 'spec_helper'

describe 'Haml' do

  before do
    @root = File.dirname(__FILE__) + '/fixtures'
  end

  it 'должен рендерить HAML файл' do
    haml = Workbench::Renderer.new "#{@root}/index.haml"
    haml.render.should == "<h1 style=\"color: red\" title=\"&amp;\">Hello world!</h1>\n"
  end

  it 'должны верно устанавливаться опции' do
    haml = Workbench::Renderer.new "#{@root}/index.haml", { :attr_wrapper => "'",:escape_attrs => false }
    haml.render.should == "<h1 style='color: red' title='&'>Hello world!</h1>\n"
  end

end
