module Workbench

  # Parse HAML file with options
  class HamlRenderer

    DEFAULT_HAML_OPTIONS = {
      :escape_attrs => true,
      :attr_wrapper => '"',
      :format => :html4
    }

    class << self

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
        Haml::Engine.new(File.read(filename), DEFAULT_HAML_OPTIONS.merge(options)).render
      end

    end

  end

end

