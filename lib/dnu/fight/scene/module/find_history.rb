# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module FindHistory
        
        def just_before_children_success
          begin
            if self.last.values.first[:children].respond_to?(:last)
              self.last.values.first[:children].last
            else
              self.last.values.first[:children]
            end
          rescue
            {}
          end
        end
        
        def childrens_find_by_scene(scene)
          self.map do |child|
            if child[scene].try(:fetch, :children).respond_to?(:last)
              child[scene][:children].last.values.first[:children].presence
            else
              child[scene].try(:fetch, :children).presence
            end
          end.compact
        end
        
      end
    end
  end
end
