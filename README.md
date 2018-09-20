# Jetstream

iPhone app that displays current weather conditions using the [DarkSky API](https://darksky.net/dev/). The app is written in Swift with an MVVM architecture. The design is intended to mimic to default weather app on iOS via a combination of `UIScrollView`, `UIStackView` and Auto Layout constraints.

## Requirements

* Xcode 10
* Swift 4.2

## Setup

Clone the repo and open the project in Xcode.

	$ git clone git@github.com:cocoascientist/Jetstream.git

## Design

The interface is built manually using `UIView` subclasses and by programmatically defining AutoLayout constraints. The hourly forecasts are shown in a `UICollectionView` nested inside a scroll view. The summary and detail views are created using `UIStackView`.

The scroll animation is accomplished by implementing delegate methods for `UIScrollViewDelegate` and modifying certain constraints based on the content offset.

The forecast model is cached using Core Data and refreshed on a background context. Changes are reflected in the UI by responding to managed object context change notifications.

SceneKit is used to create the cloud animation.

## Screenshot

![screenshot](http://i.imgur.com/oAJqVVC.gif)

## Credits

Weather Icons are provided by the [Weather Icons](https://github.com/erikflowers/weather-icons) project.

App icon created by [Baboon Designs](https://thenounproject.com/baboondesigns/).
