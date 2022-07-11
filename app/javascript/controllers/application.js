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
  const deliveryTypeEle = document.querySelector('input[name="delivery[delivery_type]"]:checked')
  if(deliveryTypeEle && deliveryTypeEle.value == '1') {
    showScheduledDate()
    return
  }
  const travelTimeEle = document.getElementById("delivery_travel_time")
  if(!travelTimeEle) return;
  const travelTime = parseInt(travelTimeEle.value)
  
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
  const scheduleDateEle = document.getElementById('delivery_scheduled_date')
  if(!scheduleDateEle) return;

  const scheduleDate = scheduleDateEle.value
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

function updateModalDeliveryId() {
  const deliveredButtons = document.querySelectorAll('.delivered-button')
  if(deliveredButtons == []) return;
  deliveredButtons.forEach(function(button) {
    button.addEventListener('click', function(e) {
      const deliveryId = e.target.getAttribute('data-delivery-id')
      const modalHiddenDeliveryId = document.getElementById('modal-hidden-delivery-id')
      if(!modalHiddenDeliveryId) return;
      modalHiddenDeliveryId.setAttribute('value', deliveryId)
    })
  })
}

function addDeliveryItemsToDelivery() {
  const addDeliveryItemsButton = document.getElementById('add-delivery-items-button')
  if(!addDeliveryItemsButton) return;
  addDeliveryItemsButton.addEventListener('click', function(e) {
    const deliveryItemsIds = Array.from(document.getElementById('added-products-tbody').querySelectorAll('.product-id')).map((e) => e.innerText)
    const deliveryItemsQuantities = Array.from(document.getElementById('added-products-tbody').querySelectorAll('.product-quantity')).map((e) => e.value)
    if(!deliveryItemsIds || !deliveryItemsQuantities) return;
    
    const idsWithQuantities = zip(deliveryItemsIds, deliveryItemsQuantities)
    const deliveryForm = document.getElementById('delivery-form')
    if(!deliveryForm) return;
    idsWithQuantities.forEach(function(idAndQuantity) {
      const input = document.createElement('input')
      input.setAttribute('type', 'hidden')
      input.setAttribute('name', 'delivery[delivery_items_attributes][][product_id]')
      input.setAttribute('value', idAndQuantity[0])
      deliveryForm.appendChild(input)
      const input2 = document.createElement('input')
      input2.setAttribute('type', 'hidden')
      input2.setAttribute('name', 'delivery[delivery_items_attributes][][quantity]')
      input2.setAttribute('value', idAndQuantity[1])
      deliveryForm.appendChild(input2)
    })
  })
}

const zip = (a, b) => a.map((k, i) => [k, b[i]]);

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementById('delivery-form')) {
    initMapsAutocomplete();

    updateMap()
    getTravelTime()
    calculateExpectedTime()
    showScheduledDate()
    onDeliveryAddressChange()
    onDeliveryTypeChange()
    onScheduleDateChange()
    updateModalDeliveryId()
  }
  
})
