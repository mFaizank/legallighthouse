module ApplicationHelper
  def format_specializations(specializations)
    specializations.map {|s| "#{s.capitalize} Law" }.join ', '
  end

  def format_price(decimal)
    "#{number_to_currency(decimal, strip_insignificant_zeros: true)} + tax"
  end

  def inbox_time(datetime)
    datetime.strftime(datetime.to_date == Date.today ? '%l:%M %P' : '%b %e')
  end

  def nav_link_to(text, path)
    klass = current_page?(path) ? 'current' : ''
    link_to(text, path, class: klass)
  end

  def language_link
    return hard_language_link if @hard_language

    args = case I18n.locale
    when :en
      ['Français', "http://www.droitphare.ca#{request.fullpath}"]
    when :fr
      ['English', "http://www.legallighthouse.ca#{request.fullpath}"]
    end

    link_to(*args)
  end

  def localized_page_path(name)
    case I18n.locale
    when :en
      page_path(name)
    when :fr
      path_map[name]
    end
  end

  def application_form_button(text)
    path = case I18n.locale
    when :en
      application_form_path
    when :fr
      formulaire_de_candidature_path
    end
  
    button_to(text, path, method: :get)
  end

  private

  def hard_language_link
    locale = ([:en, :fr] - [I18n.locale]).first
    link_to locale_map[locale], params.merge(locale: locale.to_s)
  end

  def locale_map
    {
      en: 'English',
      fr: 'Français'
    }
  end

  def path_map
    @page_map ||= {
      'how_it_works' => notre_plateforme_path,
      'lawyers' => pour_les_avocats_path,
      'vision' => notre_vision_path,
      'team' => notre_equipe_path
    }
  end
end
