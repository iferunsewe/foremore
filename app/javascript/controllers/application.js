import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

function onDeliveryAddressChange() {
  const deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if (!deliveryAddressEle) return;
  deliveryAddressEle.addEventListener("change", function(e) {
    updateMap()
    getTravelTime()
  });
}

function onDeliveryTypeChange() {
  const deliveryTypeEle = document.querySelector('input[name="delivery[delivery_type]"]')
  if (!deliveryTypeEle) return;
  deliveryTypeEle.addEventListener("change", function(e) {
    if(this.value == '1') return;
    getTravelTime()
    calculateExpectedTime()
  });
}

function onScheduleDateChange() {
  const scheduleDateEle = document.getElementById("delivery_scheduled_date")
  if (!scheduleDateEle) return;
  scheduleDateEle.addEventListener("change", function(e) {
    showScheduledDate()
  });
}

function adminOrNormalPickupAddress() {
  const pickupAddressEle = document.getElementById("delivery_pickup_address")
  const adminPickupEle = document.getElementById("delivery_pickup_address_id")
  if(pickupAddressEle && pickupAddressEle.value !== "") {
    return pickupAddressEle.innerText
  } else if (adminPickupEle && adminPickupEle.value !== "") {
    return adminPickupEle.options[adminPickupEle.selectedIndex].text;
  } else {
    return "100 overtoom, Amsterdam"
  }
}

function updateMap() {
  const deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if(!deliveryAddressEle) return;
  const pickupAddress = adminOrNormalPickupAddress()
  const deliveryAddress = deliveryAddressEle.value
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

function getTravelTime() {
  const deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if(!deliveryAddressEle) return;
  const pickupAddress = adminOrNormalPickupAddress()
  const deliveryAddress = deliveryAddressEle.value
  const travelTime = document.getElementById("delivery_travel_time")
  if(!travelTime || deliveryAddress == '') return;
  
  let service = new google.maps.DistanceMatrixService();
  service.getDistanceMatrix(
    {
      origins: [pickupAddress],
      destinations: [deliveryAddress],
      travelMode: 'BICYCLING'
    }, travelTimeCallback
  );
}

function travelTimeCallback(response, status) {
  // See Parsing the Results for
  // the basics of a callback function.
  if (status !== 'OK') {
    console.error('Unable to retrieve travel time from google. The error was: ' + status);
    return;
  }
  const travelTime = document.getElementById("delivery_travel_time") 
  if(!travelTime) return;
  const travelTimeInMinutes = response.rows[0].elements[0].duration.value / 60
  travelTime.value = travelTimeInMinutes
  calculateExpectedTime()
}


function initMapsAutocomplete() {
  let deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if (!deliveryAddressEle) return;
  new google.maps.places.Autocomplete(deliveryAddressEle);
}

function calculateExpectedTime(){
  // if the delivery type is scheduled then we don't need to calculate the expected time
  if(document.querySelector('input[name="delivery[delivery_type]"]:checked').value == '1') {
    showScheduledDate()
    return
  }
  const travelTime = parseInt(document.getElementById("delivery_travel_time").value)
  const expectedTime = document.querySelector(".expected-time")
  const expectedDay = document.getElementById("expected-day")

  if(!expectedTime || !travelTime) return;
  const prepTime = 20
  const expectedTimeInMinutes = travelTime + prepTime
  const timeToDisplay = addMinutesToCurrentDate(expectedTimeInMinutes)
  expectedTime.innerText = `${padTo2Digits(timeToDisplay.getHours())}:${padTo2Digits(timeToDisplay.getMinutes())}`
  expectedDay.innerText = 'Today'
}

function showScheduledDate() {
  const scheduleDate = document.getElementById('delivery_scheduled_date').value
  const expectedTime = document.querySelector(".expected-time")
  const expectedDay = document.getElementById("expected-day")
  if(!scheduleDate || !expectedTime) return;
  const timeToDisplay = new Date(scheduleDate)
  expectedTime.innerText = `${padTo2Digits(timeToDisplay.getHours())}:${padTo2Digits(timeToDisplay.getMinutes())}`
  if (timeToDisplay.getDate() == new Date().getDate() + 1) {
    expectedDay.innerText = 'Tomorrow'
  } else {
    expectedDay.innerText = `${padTo2Digits(timeToDisplay.getDate())}/${padTo2Digits(timeToDisplay.getMonth() + 1)}/${timeToDisplay.getFullYear()}`
  }
}

function addMinutesToCurrentDate(minutes) {
  const currentDate = new Date()
  return new Date(currentDate.getTime() + minutes * 60000)
}

function padTo2Digits(num) {
  return String(num).padStart(2, '0');
}

window.addEventListener('load', function () {
  google.maps.event.addDomListener(window, 'load', initMapsAutocomplete);

  updateMap()
  getTravelTime()
  calculateExpectedTime()
  showScheduledDate()
  onDeliveryAddressChange()
  onDeliveryTypeChange()
  onScheduleDateChange()
})
