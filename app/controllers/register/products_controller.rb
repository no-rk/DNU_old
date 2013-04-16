class Register::ProductsController < Register::ApplicationController
  private
  def wrap_clone_record(record)
    if record.respond_to?(:day) and record.day.present?
      c_record = Register::Product.new
      c_record.build_product
    else
      c_record = clone_record(record)
    end
    c_record
  end
  def set_instance_variables
    equip_arel = GameData::ItemEquip.arel_table
    @item_type_select ||= GameData::ItemType.where(equip_arel[:kind].in(["武器", "頭", "腕", "身体", "装飾"])).includes(:item_equip).inject({}){|h,r|h.tap{h[r.name]=r.id}}
  end
end
