Jetstream
====

iPhone app for showing current weather conditions, using the [Forecast API](https://developer.forecast.io/). The app is written in Swift with an MVVM architecture. The networking layer is largely inspired from [Tiny Networking](http://chris.eidhof.nl/posts/tiny-networking-in-swift.html) and the functional concepts from [LlamaKit](https://github.com/LlamaKit/LlamaKit).

Icons are provided by [Weather Icons](https://github.com/erikflowers/weather-icons).

You must [register for an API key](https://developer.forecast.io/register) before data can retrieved. Replace the key defined inside [ForecastAPI.swift](https://github.com/andyshep/Jetstream/blob/master/Jetstream/ForecastAPI.swift#L19) with your own key.

##Setup
Clone the repo and update the submodules, using the --recursive flag.

	$ git clone --recursive git@github.com:andyshep/Jetstream.git

<br>

![screenshot](http://i.imgur.com/tw7AwrT.gif)]
