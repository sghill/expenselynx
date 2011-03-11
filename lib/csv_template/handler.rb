require 'csv'

module CsvTemplate
  module ViewHelpers
    def mime_type
      if respond_to?(:template_format)
        format_extension = template_format
        p format_extension
      else
        format_extension = formats.first
      end
      Mime::Type.lookup_by_extension(format_extension.to_s) || begin
        raise "unrecognised format #{format_extension.inspect}"
      end
    end
  end

  class ActionPack3Handler < ActionView::Template::Handler
    include ActionView::Template::Handlers::Compilable

    self.default_format = Mime::CSV

    def compile(template)
      <<-RUBY
        CSV.generate do |csv|
        #{template.source}
        end
      RUBY
    end
  end
end

ActionView::Template.register_template_handler(:csvt, CsvTemplate::ActionPack3Handler)

class ActionView::Base
  include CsvTemplate::ViewHelpers
end
