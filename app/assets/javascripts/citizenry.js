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
    if ($('#companies_map_canvas').length > 0) {
      this.companiesMap = new Citizenry.Views.CompaniesMap({el: $('#companies_map_canvas')});
    }
    if ($('#company_map_canvas').length > 0) {
      this.companyMap = new Citizenry.Views.CompanyMap({el: $('#company_map_canvas')});
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

Citizenry.Views.CompanyMap = Backbone.View.extend({
  initialize: function(options) {
    this.el = options['el'];
    this.mapId = this.el.selector;
    var company = $(this.mapId).data();
    $(this.mapId).gmap().bind('init', function(event, map) {
      var geocoder = new google.maps.Geocoder();
      geocoder.geocode({'address': company.address}, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          var latlng = results[0].geometry.location;
          marker = new google.maps.Marker({
            position: latlng,
            bounds: true
          });
          marker.setMap(map);
          map.setZoom(18);
          map.setCenter(latlng);
        } else {
          console.log("Unable to find address: " + status);
        }
      });
    });
  }
});

Citizenry.Views.CompaniesMap = Backbone.View.extend({
  initialize: function(options) {
    this.el = options['el'];
    this.mapId = this.el.selector;

    // http://jquery-ui-map.googlecode.com/svn/trunk/demos/jquery-google-maps-geocoding.html
    // http://code.google.com/p/jquery-ui-map/wiki/jquery_ui_map_v_3_sample_code
    // Polyline for center?
    // var bounds = new google.maps.LatLngBounds();
    // Then for each marker, extend your bounds object:

    // bounds.extend(myLatLng);
    // map.fitBounds(bounds);
    // http://stackoverflow.com/questions/1556921/google-map-api-v3-set-bounds-and-center
    $(this.mapId).gmap({'callback': function() {
      var self = this;
      var geocoder = new google.maps.Geocoder();
      // $(this.mapId).gmap('option', 'center', new google.maps.LatLng("57.797", "12.052"));
      // 'center': '57.7973333,12.0502107', 'zoom': 10, 'disableDefaultUI':true,
      $.getJSON('/companies.json', function(data) {
        $.each(data, function(i, company) {
          // console.log(company.address);
          geocoder.geocode({'address': company.address}, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
              // console.log(results);
              var lng = results[0].geometry.location.lng();
              var lat = results[0].geometry.location.lat();
              // console.log(lat);
              // console.log(lng);
              var pos = new google.maps.LatLng(lat, lng);
              // console.log(pos);
              self.addMarker({'position': pos, 'bounds': true}).click(function() {
                self.openInfoWindow({'content': company.name}, this);
              });
            } else {
              console.log("Unable to find address: " + status);
            }
          });
        });
      // $.getJSON("http://maps.google.com/maps/geo?q="+company.address+"&key="+GMAP_API_KEY+"&sensor=false&output=json&callback=",
      //   function(data, textStatus){
      //      console.log("asdf");
      //   });
      // });
      });
    }});
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
