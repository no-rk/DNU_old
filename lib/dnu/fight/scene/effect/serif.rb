module DNU
  module Fight
    module Scene
      class Serif < BaseEffect
        
        def serif_parser
          if @serif_parser.nil?
            @serif_parser = ExecJS.compile(
              File.read("#{Rails.root}/app/assets/javascripts/plugins/peg.function.js")+
              File.read("#{Rails.root}/app/assets/javascripts/plugins/peg.parser.js")
            )
          end
          @serif_parser
        end
        
        def play_children
          history[:children] = serif_parser.call('parser.parse', @tree.to_s, 'messages')
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
