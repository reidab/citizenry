Citizenry = {};
Citizenry.Models = {};
Citizenry.Views = {};
Citizenry.Controllers = {};

Citizenry.app = {
  init: function() {
    this.controller = new Citizenry.Controllers.AppController();
  }
};

Citizenry.Controllers.AppController = Backbone.Controller.extend({
  routes: {
    'sign_in': 'showSignInForm',
    'sign_in/:provider': 'showSignInForm'
  },
  initialize: function(options) {
    _.bindAll('showSignInForm', 'focusSearchField', this);
    if($('#global_sign_in').length > 0) {
      this.signInForm = new Citizenry.Views.SignInForm({el: $('#global_sign_in')});
    }
    $(document).bind('keydown', '/', this.focusSearchField);
    $('input, textarea').placeholder();
  },
  showSignInForm: function(provider) {
    if(this.signInForm) {
      this.signInForm.toggleForm(true, provider);
    }
  },
  focusSearchField: function() {
    $('#global_search input').select();
    return false
  }
});

Citizenry.Views.SignInForm = Backbone.View.extend({
  events: {
    'click  #sign_in_link': 'signInLinkClicked'
  },
  initialize: function(options) {
    _.bindAll('signInLinkClicked', 'toggleForm', this);

    this.formDiv = $('#global_sign_in_form');
    this.form = this.formDiv.find('form');
    this.emailInput = this.form.find('#sign_in_data_email');
    this.providerSelect = this.form.find('#sign_in_data_provider');
  },
  signInLinkClicked: function(e) {
    e.preventDefault();
    this.toggleForm();
  },
  toggleForm: function(show, provider) {
    if(typeof show != 'undefined') {
      $(this.el).add('#global_sign_in_form').toggleClass('open', show);
    } else {
      $(this.el).add('#global_sign_in_form').toggleClass('open');
    } 

    if($(this.el).hasClass('open')) { this.emailInput.focus(); }

    if(typeof provider != 'undefined') {
      this.providerSelect.val(provider);
    }
  }
});

$(function() { Citizenry.app.init(); });
