class Bar

    NAMES = %w(barreau chambre upper bc ab sk mb nb ns pe nl yt nt nu)

    def self.all
      NAMES.map {|name| new(name)  }
    end

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      I18n.t ".bars.#{name}"
    end

end
