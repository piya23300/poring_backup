module PoringBackup
  class Storage

    attr_reader :setting

    def initialize setting, &block
      @setting = setting
    end

  end
end