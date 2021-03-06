module DNU
  class Data
    def self.clean_tree(tree)
      case tree
      when Hash
        tree.inject({}){ |h,(k,v)|
          h.tap{ h[k.to_sym] = self.clean_tree(v) }
        }
      when Array
        tree.map{ |v| self.clean_tree(v) }
      when Parslet::Slice, String
        tree.to_s.encode(:universal_newline => true)
      else
        tree
      end
    end
    
    def self.parse(kind, text, is_reload = false)
      begin
        tree = parser(is_reload).send(kind).parse(text)
        tree = transform(is_reload).apply(tree)
      rescue
        tree = nil
      else
        tree = self.clean_tree(tree)
      end
      tree
    end
    
    def self.parse!(kind, text, is_reload = false)
      tree = parser(is_reload).send(kind).parse(text)
      tree = transform(is_reload).apply(tree)
      tree = self.clean_tree(tree)
      tree
    end
    
    def self.parse_from_model(model, is_reload = false)
      kind = model.class.name.split("::").last.underscore
      text = model.definition
      self.parse_definition(kind, text, is_reload) || {}
    end
    
    def self.parse_definition(kind, text, is_reload = false)
      self.parse("#{kind}_definition", text, is_reload)
    end
    
    def self.parse_settings(kind, text, is_reload = false)
      self.parse("#{kind}_settings", text, is_reload)
    end
    
    def self.sync(model)
      kind = model.class.name.split("::").last.underscore
      id   = model.id
      if id.present?
        db = YAML::Store.new("#{Rails.root}/db/game_data/#{kind}.yml")
        if model.respond_to?(:to_sync_hash)
          attributes = self.clean_tree(model.to_sync_hash)
          db.transaction do
            db[:data] ||= []
            if db[:data][id-1] != attributes
              db[:data][id-1] = attributes
            end
          end
        else
          definition = self.clean_tree(model.definition)
          db.transaction do
            db[:data] ||= []
            if db[:data][id-1] != definition
              db[:data][id-1] = definition
            end
          end
        end
      end
    end
    
    def self.trainable(model, visible)
      train = GameData::Train.where({
        :trainable_type => model.class.name,
        :trainable_id   => model.id
      }).first_or_initialize
      
      train.visible = visible
      train.save!
    end
    
    def self.set_learning_conditions(model, learning_conditions)
      # 習得条件
      if learning_conditions.present?
        model.learning_conditions.destroy_all unless model.new_record?
        condition_group = 1
        if learning_conditions[:or].present?
          learning_conditions[:or].each do |condition_or|
            if condition_or[:and].present?
              group_count = condition_or[:and].count
              condition_or[:and].each do |condition|
                condition[:name] = condition[:name].to_s
                model.learning_conditions.build(condition.merge({ :condition_group => condition_group, :group_count => group_count }))
              end
            else
              group_count = 1
              condition_or[:name] = condition_or[:name].to_s
              model.learning_conditions.build(condition_or.merge({ :condition_group => condition_group, :group_count => group_count }))
            end
            condition_group = condition_group + 1
          end
        elsif learning_conditions[:and].present?
          group_count = learning_conditions[:and].count
          learning_conditions[:and].each do |condition|
            condition[:name] = condition[:name].to_s
            model.learning_conditions.build(condition.merge({ :condition_group => condition_group, :group_count => group_count }))
          end
        else
          group_count = 1
          learning_conditions[:name] = learning_conditions[:name].to_s
          model.learning_conditions.build(learning_conditions.merge({ :condition_group => condition_group, :group_count => group_count }))
        end
      end
    end
    
    def self.parser(is_reload = false)
      @@parser   = EffectParser.new if is_reload
      @@parser ||= EffectParser.new
    end
    
    def self.transform(is_reload = false)
      @@transform   = EffectTransform.new if is_reload
      @@transform ||= EffectTransform.new
    end
  end
end
