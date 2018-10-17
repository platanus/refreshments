class DoorClient
  include HTTParty
  BASE_URL = "https://hass.platan.us/api/services"

  base_uri BASE_URL

  def open_door
    self.class.post(
      "/switch/turn_on",
      body: { entity_id: "switch.fridge_door" }.to_json,
      headers: headers
    )
  end

  private

  def headers
    { "x-ha-access": "CdCBHmdkyEKK9AviGFasJnzL" }
  end
end
