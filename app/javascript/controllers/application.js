import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

function updateMap() {
  const deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if (!deliveryAddressEle) return;
  deliveryAddressEle.addEventListener("change", function(e) {
    const deliveryAddress = this.value
    updateMapOnInit(deliveryAddress)
  });
}

function updateMapOnInit(deliveryAddressValue) {
  const deliveryAddress = (deliveryAddressValue || document.getElementById("delivery_delivery_address").value)
  const pickupAddress = document.getElementById("delivery_pickup_address").innerText
  const map = document.getElementById("google-embed-map")
  if(!map) return;
  var googleApiKey = map.getAttribute('data-google-api-key');
  if (deliveryAddress !== undefined && deliveryAddress !== "") {
    var newMapUrl = `https://www.google.com/maps/embed/v1/directions?key=${googleApiKey}&origin=${pickupAddress}&destination=${deliveryAddress}&mode=bicycling`
  } else {
    var newMapUrl = `https://www.google.com/maps/embed/v1/place?key=${googleApiKey}&q=${pickupAddress}`
  }
  map.src = newMapUrl.toString()
}



function initMapsAutocomplete() {
  let deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if (!deliveryAddressEle) return;
  new google.maps.places.Autocomplete(deliveryAddressEle);
}

document.addEventListener('DOMContentLoaded', () => {
  google.maps.event.addDomListener(window, 'load', initMapsAutocomplete);

  updateMapOnInit()
  updateMap()
})
