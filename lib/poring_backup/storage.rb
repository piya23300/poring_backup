module PoringBackup
  class Storage

    attr_reader :setting
    attr_reader :notify_message

    def initialize setting, &block
      @setting = setting
    end

  end
end