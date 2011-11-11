module Workbench

  class HamlRenderer

    @options = {
      :escape_attrs => true,
      :attr_wrapper => '"',
      :format => :html4
    }

    class << self

      # @return [Hash] the list of options
      attr_accessor :options

      # Parse HAML file with options
      #
      # @param [String] filename path to file
      # @param [Hash] options options
      # @return [String] parsed content
      #
      # @example
      #   result = Workbench::HamlRenderer.render 'index.haml', { :attr_wrapper => "'", :escape_attrs => false }
      #
      def render filename, options = {}
        options = @options.merge(options)
        Haml::Engine.new(File.read(filename), options).render
      end

    end

  end

end

