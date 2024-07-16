# Tourcast

A Band's Touring Forecast App!
For Cloudwalk's Mobile Engineer test

## Running the Project

If you have make avaiable, the easiest way is to set your OpenWeather API key
in a `env.json` file and run `make test` and `make run`.

Alternatively you can provide you api with
`flutter run --dart-define=API_KEY={YOUR KEY}`

## Features

- Main screen with city's list and search field
- Details screen with 5 day forecast
- Internet availability checking to notify user
- Local persistency when network is not available
