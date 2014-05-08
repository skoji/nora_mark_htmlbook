require 'nora_mark_htmlbook/transformer.rb'

module NoraMark
  module Htmlbook
    class Generator

      def self.name
        :htmlbook
      end

      def initialize(param = {})
        @param = param
      end
      
      def convert(parsed_result, render_parameter = {})
        parsed_result = Htmlbook.transformer.transform parsed_result
        return NoraMark::Html::Generator.new(@param).convert(parsed_result, render_parameter.merge({nonpaged: true}))[0]
      end
    end
  end
end
