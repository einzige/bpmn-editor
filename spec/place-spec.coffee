Place = require '../lib/place'

describe 'Place', ->
  it 'assigns default color', ->
    place = new Place()
    expect(place.color).toBe 'white'

  it 'assigns coordinates', ->
    place = new Place(x: 1)

    expect(place.x).toBe 1
    expect(place.y).toBe 0
