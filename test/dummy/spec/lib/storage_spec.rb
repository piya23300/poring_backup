require "rails_helper"

module PoringBackup
  describe Storage do
    let(:store) {
      @store = Storage.new(Setting.new)
    }
    context "initialize" do
      it "setting" do
        expect(store.setting).to be_a(Setting) 
      end
    end

  end
end
