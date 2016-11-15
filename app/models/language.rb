class Language

  class << self
    def all
      filter(LanguageList::COMMON_LANGUAGES)
        .sort_by {|l| l.common_name }
        .map {|l| new(l) }
    end

    def default
      [
        ['english', 'English'],
        ['french', 'French'],
        ['other','Add other']
      ]
    end

    def filter(languages)
      languages.delete_if {|l| %w(English French).include?(l.name) }
    end
  end

  def initialize(language)
    @language = language
  end

  def name
    @language.iso_639_1
  end

  def to_s
    @language.common_name
  end

end
