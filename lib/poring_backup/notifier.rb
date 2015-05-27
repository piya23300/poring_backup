module PoringBackup
  class Notifier

    attr_reader :setting

    def initialize setting, &block
      @setting = setting
    end

    def notify!
      
    end

  end
end 
