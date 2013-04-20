class GameData::MapsController < GameData::ApplicationController
  private
  def set_instance_variables
    @map_list    = GameData::Map.all.inject({}){ |h,r| h.tap{h[r.name]=r.id} }
    @map_select  = (1..26).inject({}){ |h,n| h.tap{ h[n] = n } }
    @vision_size = 5
    @landforms   = GameData::Landform.all
  end
  def build_record(record)
    record.map_size = (params[:map_size] || 26).to_i
    record.base = "field"
    for x in 1..record.map_size
      for y in 1..record.map_size
        record.map_tips.build(:x => x, :y => y, :landform_image => :plain, :collision => 0, :opacity => 0)
      end
    end
  end
end
