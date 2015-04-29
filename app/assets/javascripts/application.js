// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var bounds = new google.maps.LatLngBounds();
var markersArray = [];
var SF_LAT = 38.66919;
var SF_LNG = 139.7413805;
var QUERY_DELAY = 11;
var inactive = false;
var open_infowindow = false;

$(document).ready(function() {
  // initialize the map on load
  initialize();
});

/**
 * Initializes the map and some events on page load
 */

var initialize = function() {
  // Define some options for the map
  var mapOptions = {
    center: new google.maps.LatLng(SF_LAT, SF_LNG),
    zoom: 5,

    // hide controls
    panControl: false,
    streetViewControl: false,

    // reconfigure the zoom controls
    zoomControl: true,
    zoomControlOptions: {
      position: google.maps.ControlPosition.RIGHT_BOTTOM,
      style: google.maps.ZoomControlStyle.SMALL
    }
  };

  // create a new Google map with the options in the map element
  var map = new google.maps.Map($('#map_canvas')[0], mapOptions);

  bind_controls(map);
}




/**
 * Bind and setup search control for the map
 *
 * param: map - the Google map object
 */
var bind_controls = function(map) {
  // get the container for the search control and bind and event to it on submit
  var controlContainer = $('#control_container')[0];
  google.maps.event.addDomListener(controlContainer, 'submit', function(e) {
    e.preventDefault();
    search(map);
  });

  // get the search button and bind a click event to it for searching
  var searchButton = $('#map_search_submit')[0];
  google.maps.event.addDomListener(searchButton, 'click', function(e) {
    e.preventDefault();
    search(map);
  });





  // push the search controls onto the map
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(controlContainer);
}

/**
 * Makes a post request to the server with the search term and
 * populates the map with the response businesses
 *
 * param: map - the Google map object
 */
var search = function(map) {
  var searchTerm = $('#map_search input[type=text]').val();

  if (inactive === true) { return };

  // post to the search with the search term, take the response data
  // and process it
  $.post('/search', { term: searchTerm }, function(data) {
    inactive = true;

    // do some clean up
    $('#results').show();
    $('#results').empty();
    clearMarkers();

    // iterate through each business in the response capture the data
    // within a closure.
    data['businesses'].forEach(function(business, index) {
      capture(index, map, business);
    });
  });
};

/**
 * Capture the specific business objects within a closure for setTimeout
 * or else it'll execute only on the last business in the array
 *
 * param: i - the index the business was at in the array, used to the
 *            timeout delay
 * param: map - the Google map object used for geocoding and marker placement
 * param: business - the business object from the response
 */
var capture = function(i, map, business) {
  setTimeout(function() {
    if (i === 15) {
      inactive = false;
    }

    $('#results').append(build_results_container(business));

    // get the geocoded address for the business's location
    geocode_address(map, business['name'], business['location']);
  }, QUERY_DELAY * i); // the delay on the timeout
};

/**
 * Builds the div that'll display the business result from the API
 *
 * param: business - object of the business response
 */
var build_results_container = function(business) {
  return [
  
    '<div class="result">',
      // '<p class="like"><a href="">★</a></p>',
      '<form accept-charset="UTF-8" action="/mypage" method="post" data-remote="true">',

      '<p class="like"><input type="submit" value="★" onclick="onclick_func()">',
      // '<input name="authenticity_token" type="hidden" value="',$$('input[name="authenticity_token"]')[0].value,'" />',
      '<input name="shop[name]" type="hidden" value="',business['name'],'" />',
      '<input name="shop[coordinate]" type="hidden" value="',business['location']['coordinate']['latitude'],'＃',
      business['location']['coordinate']['longitude'],
      '" />',
      '<input name="shop[image_url]" type="hidden" value="',business['image_url'],'" />',
      '<input name="shop[display_phone]" type="hidden" value="',business['display_phone'],'" />',
      '<input name="shop[location_display_address]" type="hidden" value="',
      business['location']['display_address'][2], business['location']['display_address'][1], business['location']['display_address'][0],
      '" />',

      '<input name="shop[url]" type="hidden" value="',business['url'],'" />',
      '<input name="shop[star]" type="hidden" value="',business['rating_img_url'],'" />',
      '<input name="shop[review_count]" type="hidden" value="',business['review_count'],'" />',
      '</p>',

      '</form>', 
       
      '<img class="biz_img" src="', business['image_url'], '">',
      '<h5><a href="', business['url'] ,'" target="_blank">', business['name'], '</a></h5>',
      '<img src="', business['rating_img_url'], '">',
      '<p>', business['review_count'], ' reviews</p>',
      '<p class="clear-fix"></p>',
    '</div>'
    
  ].join('');
};

// click時に呼ばれる関数
function onclick_func(){
  // shop_f.name = business['name'];
  shop_f.innerHTML = "お気に入りに追加されました！";

}

// Enterキーでsubmitしないようにする。
// $(function() {
//   $(document).on("keypress", "input:not(.allow_submit)", function(event) {
//     return event.which !== 13;
//   });
// });

/**
 * Geocode the address from the business and drop a marker on it's
 * location on the map
 *
 * param: map - the Google map object to drop a marker on
 * param: name - the name of the business, used for when you hover
 *               over the dropped marker
 * param: location_object - an object of the businesses address
 */
var geocode_address = function(map, name, location_object) {
  var geocoder = new google.maps.Geocoder();

  var address = [
    location_object['address'][0],
    location_object['city'],
    location_object['country_code']
  ].join(', ');

  // geocode the address and get the lat/lng
  geocoder.geocode({address: address}, function(results, status) {
    if (status === google.maps.GeocoderStatus.OK) {

      // create a marker and drop it on the name on the geocoded location
      var marker = new google.maps.Marker({
        animation: google.maps.Animation.DROP,
        map: map,
        position: results[0].geometry.location,
        title: name
      });

      // ★情報ウィンドウ
        var infoWindow = new google.maps.InfoWindow({
            content: marker.title,
            size: new google.maps.Size(200,50)
        });

       //①つめOK ★クリックしたら、ウィンドウがでるよ。
        // google.maps.event.addListener(marker, 'click', function() {
        //     infoWindow.open(map, marker);
        // });open_infowindow

      //②つめOK
      google.maps.event.addListener(marker, 'click', function(){
          if(open_infowindow){
            open_infowindow.close();
          }
        infoWindow.open(map, marker);
        });

      

       // ★dblclickたら、ウィンドウがとじる。
        google.maps.event.addListener(marker, 'dblclick', function() {
            infoWindow.close(map, marker);
        });

       // 吹き出しを消す
        var closeInfoWindow = function(){
            marker.closeInfoWindow();
        }


      // save the marker object so we can delete it later
      bounds.extend(results[0].geometry.location);
      map.fitBounds(bounds);
      markersArray.push(marker);
    } else {
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
};

/**
 * Remove all of the markers from the map by setting them
 * to null
 */
var clearMarkers = function() {
  markersArray.forEach(function(marker) {
    marker.setMap(null);
  });

  markersArray = [];
};
