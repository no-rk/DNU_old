# encoding: UTF-8
module DNU
  module Fight
    module State
      module Target
        
        def avg_value
          size>=1 ? sum{ |c| yield(c) }.to_f/size.to_f : 0
        end
        
        def sum_value
          sum{ |c| yield(c) }
        end
        
        def min_value
          yield min{ |a,b| yield(a) <=> yield(b) }
        end
        
        def max_value
          yield max{ |a,b| yield(a) <=> yield(b) }
        end
        
        def live
          self.find_all{ |child|  child.live }.extend Target
        end
        
        def dead
          self.find_all{ |child|  child.dead }.extend Target
        end
        
        def turn_end
          self.find_all{ |child|  child.turn_end }.extend Target
        end
        
        def turn_end_not
          self.find_all{ |child| !child.turn_end }.extend Target
        end
        
        def find_by_team(team)
          self.find_all{ |child| child.team == team }.extend Target
        end
        
        def find_by_team_not(team)
          self.find_all{ |child| child.team != team }.extend Target
        end
        
        def team
          self.uniq{ |child| child.team }.map{ |child| child.team }.extend Target
        end
        
        def random(active)
          self.find_all{ |child| ((child.team==active.team ? -1 : 1)*child.Position + active.Position).abs <= active.Range + 1 }.sample || self.sample
        end
        
        def find_by_kind(kind)
          self.find_all{ |child| child.kind.to_s==kind.to_s }.extend Target
        end
        
        def find_by_name(name)
          self.find_all{ |child| child.name.to_s==name.to_s }.extend Target
        end
        
        def find_by_position(position)
          self.find_all{ |child| child.Position==position }.extend Target
        end
        
        def find_by_parent(parent)
          self.find_all{ |child| child.parent==parent }.extend Target
        end
        
        def find_by_parent_effect(parent)
          self.find_all{ |child| child.parent_effect.type==parent.type and child.parent_effect.name==parent.name }.extend Target
        end
        
        def 自(active)
          lambda{ active }
        end
        
        def 味(active)
          self.live.find_by_team(active.team)
        end
        
        def 敵(active)
          self.live.find_by_team_not(active.team)
        end
        
        def 敵味(active)
          self.live
        end
        
        def 味敵(active)
          self.live
        end
        
        def 味墓地(active)
          self.dead.find_by_team(active.team)
        end
        
        def 敵墓地(active)
          self.dead.find_by_team_not(active.team)
        end
        
        def 敵味墓地(active)
          self.dead
        end
        
        def 味敵墓地(active)
          self.dead
        end
        
        def 単(passive, active, target)
          target.try(:sample) || passive || random(active)
        end
        
        def ラ(passive, active, target)
          lambda{ target.try(:sample) || random(active) }
        end
        
        def 全(active, passive, target)
          self.blank? ? nil : self
        end
        
        def 低(tree, active=nil, target=nil)
          status_or_disease_name = tree[:status_name] || tree[:disease_name].keys.first
          ratio = tree[:ratio] ? :ratio : :to_f
          lambda{ target.try(:sample) || self.min{ |a,b| a.send(status_or_disease_name).send(ratio) <=> b.send(status_or_disease_name).send(ratio) } }
        end
        
        def 高(tree, active=nil, target=nil)
          status_or_disease_name = tree[:status_name] || tree[:disease_name].keys.first
          ratio = tree[:ratio] ? :ratio : :to_f
          lambda{ target.try(:sample) || self.max{ |a,b| a.send(status_or_disease_name).send(ratio) <=> b.send(status_or_disease_name).send(ratio) } }
        end
        
        def 竜(master)
          # 種類が竜でかつ親がmasterであるキャラクターを探す。
          if master.respond_to?(:call)
            find_by_kind(:Dragon).find_by_parent(master.call)
          else
            master.inject([]){ |s,c| s += find_by_kind(:Dragon).find_by_parent(c) }.extend Target
          end
        end
        
        def 人形(master)
          # 種類が人形でかつ親がmasterであるキャラクターを探す。
          if master.respond_to?(:call)
            find_by_kind(:Puppet).find_by_parent(master.call)
          else
            master.inject([]){ |s,c| s += find_by_kind(:Puppet).find_by_parent(c) }.extend Target
          end
        end
        
        def 召喚(master)
          # 種類が召喚でかつ親がmasterであるキャラクターを探す。
          if master.respond_to?(:call)
            find_by_kind(:Summon).find_by_parent(master.call)
          else
            master.inject([]){ |s,c| s += find_by_kind(:Summon).find_by_parent(c) }.extend Target
          end
        end
        
      end
    end
  end
end
