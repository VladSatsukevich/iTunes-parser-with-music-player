
# iTunes parser with music player

A music player made for iOS devices using UIKit and AVKit

## Features

- Designed using Clean Swift pattern https://clean-swift.com/clean-swift-ios-architecture
- JSON parser which can search information about track 
- At each cell user can get that data with image and sound url
- User can listen to selected track and add it to favorite list with local data base as Core Data
- Swipable action in player
- Player continues to play next track after the current track is completed
- Also you can listen to music by minimizing the application


## Installation

GitHub client requires IOS v14+ and Xcode 13+ to run. To run the app, install the dependencies using cocoaPods. Open the terminal in the application folder and run the following command

```bash
  pod install
```
    
    
## Library

GitHub client is currently extended with the following libraries. Instructions on how to use them are linked below.

| Library | README | 

- | Alamofire | https://github.com/Alamofire/Alamofire/blob/master/README.md |
- | Keychain | https://github.com/evgenyneu/keychain-swift/blob/master/README.md |
- | SDWebImage | https://github.com/SDWebImage/SDWebImage/blob/master/README.md |


## Instructions for use

At first your favorite list will be empty and you should go to second contoller which named as Search

![App Screenshot](https://i.postimg.cc/c4qrNg5K/Search-1.png)

After that you should enter data which you want to get

![App Screenshot](https://i.postimg.cc/NfJGjKd7/Search-2.png)

You can play this track by clicking on it

![App Screenshot](https://i.postimg.cc/BQdX5hKw/never-gonna-give-you-up.png)

Or to add it to your favorite list, just by clicking the like button

![App Screenshot](https://i.postimg.cc/7PzQLdXB/Search-liked.png)

By clicking the like button you form your favorite playlist

![App Screenshot](https://i.postimg.cc/7ZXqWf2T/Favorite-list-1.png)

You can add any tracks you want to your favorite playlist and to listen them. They will be sorted alphabetically

![App Screenshot](https://i.postimg.cc/MTYTqdcd/Favorite-list-2.png)

You can listen to any track you want just cliking on it. 
At music player you can change track by cliking next/forward buttons.
After track ending the next track will be playing automatically.
Also you can change music volume and playing track position by moving the corresponding sliders.
In conclusion you can listen to music by minimizing the app.

![App Screenshot](https://i.postimg.cc/kGKDLqQR/Player-final.png)

Finaly you can remove any track from your favorites just by swiping it and pushing "Delete" button or unlike it in Search contoller.

![App Screenshot](https://i.postimg.cc/kXWj9Hqx/Delete.png)
