# encoding: utf-8
require 'spec_helper'

describe Workbench::Cli do

  describe '#version' do

    it 'вернуть номер версии' do
      capture(:stdout){ Workbench::Cli.start(['version']) }.should =~ /Version: #{Workbench::VERSION}/
    end

  end

  describe '#js' do

    it 'вернуть список JSбиблиотек' do
      capture(:stdout){ Workbench::Cli.start(['js']) }.should =~ /jquery =>/
    end

  end

end
