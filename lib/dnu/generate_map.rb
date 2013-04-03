require 'RMagick'
module DNU
  module GenerateMap
    def self.apply(map)
      images_path = "#{Rails.root}/app/assets/images"
      # 作成済みならおしまい
      return if File.exist?("#{images_path}/#{map.name}.png")
      # マップチップ
      tip_img = {}
      GameData::MapTip.pluck("distinct landform").each do |landform|
        landform_img = Magick::ImageList.new("#{images_path}/#{landform}.png")
        tip_columns = landform_img.columns/2
        tip_rows    = landform_img.rows/10
        tip_img[landform] = []
        for y in 0..9
          for x in 0..1
            tip_img[landform].push(landform_img.crop(x*tip_columns, y*tip_rows, tip_columns, tip_rows))
          end
        end
      end
      # ベースチップ
      base_img = Magick::ImageList.new("#{images_path}/base.png")
      # ベースマップ生成
      map_img = Magick::Image.new(32*map.map_tips.maximum(:x), 32*map.map_tips.maximum(:y), Magick::TextureFill.new(base_img))
      # 地形貼り付け
      map.map_tips.find_each do |map_tip|
        landform = map_tip.landform
        y = 32*(map_tip.x-1)
        x = 32*(map_tip.y-1)
        map_img = map_img.composite(tip_img[landform][   left_up(map_tip)], x   , y   , Magick::OverCompositeOp)
        map_img = map_img.composite(tip_img[landform][  right_up(map_tip)], x+16, y   , Magick::OverCompositeOp)
        map_img = map_img.composite(tip_img[landform][ left_down(map_tip)], x   , y+16, Magick::OverCompositeOp)
        map_img = map_img.composite(tip_img[landform][right_down(map_tip)], x+16, y+16, Magick::OverCompositeOp)
      end
      map_img.write("#{images_path}/#{map.name}.png")
      map_img
    end
    private
    def self.left_up(map_tip)
      landform = map_tip.landform
      if landform != (map_tip.left.try(:landform) || landform) and landform != (map_tip.up.try(:landform) || landform)
        0
      elsif landform != (map_tip.left.try(:landform) || landform)
        4
      elsif landform != (map_tip.up.try(:landform) || landform)
        8
      elsif landform != (map_tip.left_up.try(:landform) || landform)
        12
      else
        16
      end
    end
    def self.right_up(map_tip)
      landform = map_tip.landform
      if landform != (map_tip.right.try(:landform) || landform) and landform != (map_tip.up.try(:landform) || landform)
        1
      elsif landform != (map_tip.right.try(:landform) || landform)
        5
      elsif landform != (map_tip.up.try(:landform) || landform)
        9
      elsif landform != (map_tip.right_up.try(:landform) || landform)
        13
      else
        17
      end
    end
    def self.left_down(map_tip)
      landform = map_tip.landform
      if landform != (map_tip.left.try(:landform) || landform) and landform != (map_tip.down.try(:landform) || landform)
        2
      elsif landform != (map_tip.left.try(:landform) || landform)
        6
      elsif landform != (map_tip.down.try(:landform) || landform)
        10
      elsif landform != (map_tip.left_down.try(:landform) || landform)
        14
      else
        18
      end
    end
    def self.right_down(map_tip)
      landform = map_tip.landform
      if landform != (map_tip.right.try(:landform) || landform) and landform != (map_tip.down.try(:landform) || landform)
        3
      elsif landform != (map_tip.right.try(:landform) || landform)
        7
      elsif landform != (map_tip.down.try(:landform) || landform)
        11
      elsif landform != (map_tip.right_down.try(:landform) || landform)
        15
      else
        19
      end
    end
  end
end
