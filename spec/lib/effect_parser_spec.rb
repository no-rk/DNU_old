require 'spec_helper'

describe EffectParser do
  describe "target" do
    before do
      @tree = EffectParser.new.target.parse(text)
    end
    
    context "敵" do
      let(:text){ "敵" }
      it { expect{@tree}.not_to raise_error }
    end
    
    context "自以外敵味全" do
      let(:text){ "自以外敵味全" }
      it { expect{@tree}.not_to raise_error }
    end
  end
end
