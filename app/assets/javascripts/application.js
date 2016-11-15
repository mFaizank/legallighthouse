// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require rails.validations
//= require rails.validations.simple_form

// $('#user_business').change(function() {
//     $('.user_name, .user_title').toggle(this.checked);
// });

// jquery.readyselector.js

(function ($) {
  var ready = $.fn.ready;
  $.fn.ready = function (fn) {
    if (this.context === undefined) {
      // The $().ready(fn) case.
      ready(fn);
    } else if (this.selector) {
      ready($.proxy(function(){
        $(this.selector, this.context).each(fn);
      }, this));
    } else {
      ready($.proxy(function(){
        $(this).each(fn);
      }, this));
    }
  }
})(jQuery);

$(document).ready(function() {
  $('.profile-link').hover(function() {
    $(this).toggleClass('hover');
    $('.drop-down').toggle();
  });

  $('.drop-down').hover(function() {
    $(this).toggle();
    $('.profile-link').toggleClass('hover');
  });

  $('.accordion-tabs-minimal').each(function(index) {
    $(this).children('li').first().children('a').addClass('is-active').next().addClass('is-open').show();
  });

  $('.accordion-tabs-minimal').on('click', 'li > a.tab-link', function(event) {
    if (!$(this).hasClass('is-active')) {
      event.preventDefault();
      var accordionTabs = $(this).closest('.accordion-tabs-minimal');
      accordionTabs.find('.is-open').removeClass('is-open').hide();

      $(this).next().toggleClass('is-open').toggle();
      accordionTabs.find('.is-active').removeClass('is-active');
      $(this).addClass('is-active');
    } else {
      event.preventDefault();
    }
  });

  $('.more').click(function() {
    $(this).parent().parent().find('.short').toggle();
    $(this).parent().parent().find('.long').toggle();
    return false;
  });

  $('.select').click(function() {
    var form = $(this).parent();
    var service = form.parent().parent().find('.service').text();
    var hidden = $('<input type="hidden" name="service" value="' + service + '">');
    hidden.appendTo(form);
  });
})

var section = 1;

function toggleSection() {
  if (section == 1) {
    $('.new_application .next').hide()
    $('.new_application .previous, .new_application .apply')
      .css('display', 'inline-block');
    section = 2
  } else {
    $('.new_application .next').css('display', 'inline-block');
    $('.new_application .previous, .new_application .apply').hide();
    section = 1
  }

  $('.new_application section').toggle()
  $('.new_application').enableClientSideValidations();
}

var barsSelector = '[name="application[bars][]"]';
var checkedBarsSelector = barsSelector + ':checked';

function copyFields() {
  var firstName = $('#application_first_name').clone()
  firstName.attr('name', 'first_name')
  firstName.hide()

  var lastName = $('#application_last_name').clone()
  lastName.attr('name', 'last_name')
  lastName.hide()

  var checkedBars = $(checkedBarsSelector).clone()
  checkedBars.attr('name', 'bars[]')
  checkedBars.hide()

  var form = $('.no-qc form')
  firstName.appendTo(form)
  lastName.appendTo(form)
  checkedBars.appendTo(form)
}

var otherHtml = '<input class="specialization_other" type="text">';

var removeLanguage = function() {
  $(this).parent().remove()

  return false;
}

function addLanguage() {
  $('.languages').last().after($('.languages').first().clone());
  var newLast = $('.languages').last();
  newLast.find('.remove-language').click(removeLanguage);
  newLast.show();
}

var showingBarError = false;
var showingLanguageError = false;

function errorHtml(name, message) {
  var el = $('<span>');
  el.addClass('error ' + name + '-error');
  el.text(message);

  return el;
}

function validateFirstPage() {
  var valid = true;

  if (!$('#application_first_name').val() ||
    !$('#application_last_name').val()) {
    valid = false;
  }

  if (!$(checkedBarsSelector).length) {
    if (!showingBarError) {
      var message;
      if ($('html').prop('lang') == 'en') {
        message = 'please select at least 1 bar'
      } else {
        message = 'veuillez sélectionner au moins un Barreau'
      }

      var error = errorHtml('bar', message);
      $('.checkboxes').first().after(error);
    }

    showingBarError = true;
    valid = false;
  }

  return valid;
}

function validateSecondPage() {
  if (!($('#application_languages_english')[0].checked ||
    $('#application_languages_french')[0].checked)) {
      if (!showingLanguageError) {
        var message;
        if ($('html').prop('lang') == 'en') {
          message = 'please select at least one of English and French'
        } else {
          message = 'veuillez sélectionner Francais et/ou Anglais'
        }

        var error = errorHtml('language', message);
        $('.checkboxes').last().after(error);
      }

      showingLanguageError = true;

      return false;
  }

  return true;
}

$('body.applications-new, body.applications-create').ready(function() {

  var variables = $('.variables')

  if(variables.data('invalid')) {
    toggleSection();

    var areas = variables.data('areas');
    var languages = variables.data('languages');

    if (areas) {
      $.each(areas.split(','), function(index, item) {
        if (index == 0) {
          var other = $('#application_specializations_other');
          other.prop('checked', true);
          other.parent().after($(otherHtml));
          $('.add-specialization').show();
        } else {
          $('.specialization_other').last().after($(otherHtml));
        }

        $('.specialization_other').last().val(item)
      });
    }

    if (languages) {
      $.each(languages.split(','), function(index, item) {
        if (index == 0) {
          $('.add-language').show();
        }

        addLanguage();
        $('.languages').last().find('option[value=' + item + ']')
          .prop('selected', true);
      });
    }
  }

  $(barsSelector).change(function() {
    if (showingBarError && this.checked) {
      $('.bar-error').hide();
      showingBarError = false;
    }
  });

  $('#application_languages_english, #application_languages_french')
    .change(function() {
      if (showingLanguageError && this.checked) {
        $('.language-error').hide();
        showingLanguageError = false;
      }
  });

  $('.new_application .next').click(function() {
    if (!validateFirstPage()) {
      return false;
    }

    if(!$('#application_bars_barreau')[0].checked) {
      $('.new_application section:first-child, .new_application .next').hide();
      copyFields();
      $('.no-qc').show();
    } else if ($(checkedBarsSelector).length > 1) {
      toggleSection();
      $('.other-bars').show();
    } else {
      toggleSection();
      $('.other-bars').hide();
    }

    return false;
  });

  $('.new_application .previous').click(function() {
    toggleSection();

    return false;
  });

  $('#application_specializations_other').change(function() {
    if (this.checked) {
      $(this).parent().after($(otherHtml));
      $('.specialization_other').last().focus();
      $('.add-specialization').show();
    } else {
      $('.specialization_other').remove();
      $('.add-specialization').hide();
    }
  });

  $('.add-specialization').click(function() {
    $('.specialization_other').last().after($(otherHtml));
    $('.specialization_other').last().focus();

    return false;
  });

  $('#application_languages_other').change(function() {
    if (this.checked) {
      addLanguage();
      $('.add-language').show();
    } else {
      var first = $('.languages').first().clone();
      $('.languages').remove();
      $(this).parent().after(first);
      $('.add-language').hide();
    }
  });

  $('.add-language').click(function() {
    addLanguage();

    return false;
  });

  $('.apply').click(function() {
    var form = $('.new_application');

    if (!form
      .isValid(form[0].ClientSideValidations.settings.validators) |
      !validateSecondPage()) {
        return false;
      }

    $('.specialization_other').each(function(index, item) {
      var value = $(item).val();

      if (value.trim().length) {
        var field = $('<input type="hidden" value="' + value + '" name="application[specializations][]">');
        field.appendTo($('.new_application'));
      }
    });

    $('.languages select:visible').each(function(index, item) {
      var field = $('<input type="hidden" value="' + item.value + '" name="application[languages][]">');
      field.appendTo($('.new_application'));
    });
  });
});

$('body.services-new, body.services-edit, body.services-update').ready(function() {
  var caseSpecific = $('#service_case_specific');
  var startingAt = $('#service_starting_at');

  if (caseSpecific[0].checked) {
    $('#service_fixed_fee').prop('disabled', true);
    startingAt.prop('disabled', true)
      .parent().css('opacity', 0.5);
  }

  if (startingAt[0].checked) {
    caseSpecific.prop('disabled', true)
      .parent().css('opacity', 0.5);
  }

  caseSpecific.change(function() {
    if (this.checked) {
      $('#service_fixed_fee').val('').prop('disabled', true)
        .next().remove();
      startingAt.prop('checked', false)
        .prop('disabled', true)
        .parent().css('opacity', 0.5);
    } else {
      $('#service_fixed_fee').prop('disabled', false);
      startingAt.prop('disabled', false)
        .parent().css('opacity', 1);
    }
  });

  startingAt.change(function() {
    if (this.checked) {
      caseSpecific.prop('checked', false)
        .prop('disabled', true)
        .parent().css('opacity', 0.5);
    } else {
      caseSpecific.prop('disabled', false)
        .parent().css('opacity', 1);
    }
  });
});
