module PoringBackup
  class Storage

    attr_reader :setting
    attr_reader :notify_text

    def initialize setting, &block
      @setting = setting
    end

  end
end