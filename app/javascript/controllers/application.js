import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

function updateMapFromDeliveryAddress() {
  const deliveryAddressEle = document.getElementById("delivery_delivery_address")
  if (!deliveryAddressEle) return;
  deliveryAddressEle.addEventListener("change", function(e) {
    const deliveryAddress = this.value
    const map = document.getElementById("google-embed-map")
    if (deliveryAddress !== undefined && deliveryAddress !== "") {
      var newMapUrl = new URL(map.src);
      newMapUrl.searchParams.set('destination', deliveryAddress);
      newMapUrl.searchParams.delete('zoom')
    } else {
      var newMapUrl = map.getAttribute('data-fallback-url');
    }
    map.src = newMapUrl.toString()
  });
}

document.addEventListener('DOMContentLoaded', () => {
  updateMapFromDeliveryAddress()
})
