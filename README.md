![Let Swift iOS](http://i.imgur.com/MVujfzZ.png)
#
[![Build Status](https://www.bitrise.io/app/7a26c93ad5a8995a.svg?token=UiTe2gkL-Nq1vXmW6Opxiw&branch=master)](https://www.bitrise.io/app/7a26c93ad5a8995a) ![Platform](https://camo.githubusercontent.com/783873a5a5968925c13e4b7748d284c56e3e676d/68747470733a2f2f636f636f61706f642d6261646765732e6865726f6b756170702e636f6d2f702f4e53537472696e674d61736b2f62616467652e737667) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/DroidsOnRoids/let-swift-app/blob/master/LICENSE)

LetSwift App is supporting the biggest iOS developers meetup in Poland - Let Swift, which takes place in Wrocław.

This app allows you to keep up to date with the latest events info like speakers descriptions, lectures topics or previous events photo galleries. Additionally, user may contact us via contact form.

![Screenshots](http://i.imgur.com/IRCzYt9.jpg)

## Features
- [x] Facebook login
- [x] Events and lectures info
- [x] Facebook event attending
- [x] Local event notifications
- [x] Event photo gallery
- [x] Spekakers list and details
- [x] Contact form
- [ ] Offline mode

## Communication
* If you **found a bug** or have a **feature request** - open an issue.
* If you want to **contribute** - submit a pull request.

## Requirements
* iOS 9+
* Xcode 8.2+
* Swift 3.1

## Installation guide
#### Download repo
```
$ git clone https://github.com/DroidsOnRoids/let-swift-app.git
$ cd let-swift-app
```
#### Install pods
```
$ pod install
```
#### Setup tokens file
```
$ TOKEN_FILE=LetSwift/Resources/Config.xcconfig
$ echo "FACEBOOK_APP_ID = <enter Facebook app ID here>" > $TOKEN_FILE
```
#### Setup analytics token (optionally)
```
$ echo "FABRIC_KEY = <enter Fabric API token here>" >> $TOKEN_FILE
```

And finally open *LetSwift.xcworkspace* and **run the app**

## License
Let Swift App is licensed under Apache License 2.0. [See LICENSE](https://github.com/DroidsOnRoids/let-swift-app/blob/master/LICENSE) for details.

## About us
![Droids On Roids](http://i.imgur.com/J1XxjXL.png)

Let Swift App is maintained by Droids On Roids. For more details visit our [website](https://www.thedroidsonroids.com/).

Check out our other [open source projects](https://github.com/DroidsOnRoids) and [our blog](https://www.thedroidsonroids.com/blog).

##
[![App Store](https://devimages.apple.com.edgekey.net/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg)](https://itunes.apple.com/us/app/let-swift/id1265027315?l=pl&ls=1&mt=8)
