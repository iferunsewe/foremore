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
    let newMapUrl = new URL(map.src);
    newMapUrl.searchParams.set('destination', deliveryAddress);
    newMapUrl.searchParams.delete('zoom')
    console.log(newMapUrl.toString())
    map.src = newMapUrl.toString()
  });
}

document.addEventListener('DOMContentLoaded', () => {
  updateMapFromDeliveryAddress()
})
