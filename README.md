#Edenjs Form

Setup
 
1. Need to put the following in config.js 
config.google = {
  maps : 'key',
};

2. Need to put the following build function in design.js
// set footer
let ft = '<script src="//maps.googleapis.com/maps/api/js?libraries=places&key=key"></script>';
ft += '<script src="https://api.addressfinder.io/assets/v3b/widget.js"></script>';

3. Need to install node module
-@google\maps
-leaflet

