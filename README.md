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
- Local persistency when network is not reachable

## Retrospective

Given the simplicity of the project's criteria, some decisions were made in favor of a more straightforward and less abstract implementation with less
dependencies.

The architecture was modeled on top of a few Riverpod providers and notifiers,
handling data and behaviour for a primarily reactive and stateless UI layer.

Tests were used to drive the development forward, although coverage was not
100%. Only precisely enough to make the foundational code was consistent to
leverage the higher-level application layer.

Overall a very fun take-home, looking forward for the feedback :)
