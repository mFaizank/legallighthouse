class Specialization

    NAMES = %w(corporate labor intellectual immigration civil tax realestate)

    def self.all
      NAMES.map {|n| new(n)  } + [new('other')]
    end

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      I18n.t ".specializations.#{name}"
    end

end
