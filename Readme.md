
# LifeupSnap

LifeupSnap is a mini framework develop by Khwan Siricharoenporn aka(DEVG). If you need to use camera app but you lazy to implement. You can use this frame work which in part of this has four features.

## Installation

Use the package manager [pod](https://cocoapods.org) to install LifeupSnap.

```bash
pod 'LifeupSnap'
```

## Version
```bash
beta 0.1.6 -> pod 'LifupSnap', '0.1.6'
```

## Screen Shots
![image](https://drive.google.com/open?id=1IrkQK_N-PF4_dXJ4Y7F4O8WrtctlSoKV)
![image](https://drive.google.com/open?id=1T8ixMt8a0e9WnyJNc-O9SGXJyRUYsJU8)
![image](https://drive.google.com/open?id=10gMpEOnTaumI-2d_EH1XJ4-JvGUpqfu9)
![image](https://drive.google.com/open?id=1XjwRSMUAPU7zrqD-RdWDADedtIezdZFg)
![image](https://drive.google.com/open?id=1XwZOHR-lJPnA6681bQXQSzkj4m0aYO5l)
![image](https://drive.google.com/open?id=1wQW4Uf74Xiw27RemfdfhSb3W8BAGZGVZ)

## Features

- Original -> (.original) => Is camera capture according by your device screen size.
- Square -> (.square) => Is camera capture and will convert original size to square size.
- Video -> (.video) => Is camera capture video according by your device screen size. (max duration is 30 second.)
- Boomerang -> (.boomerang) => Is a loop of video.Which this feature will generate loop video from original video and merge to one file like a Boomerang of FB. (max duration is 10 second.)
## Usage

```swift
import LifeupSnap

let lfsSnapViewController = LFSSnapViewController()
lfsSnapViewController.delegate = self
lfsSnapViewController.features = [.original, .square, .boomerang, .video]

navigationController?.present(lfsSnapViewController, animated: true, completion: nil)

//OR

navigationController?.push(lfsSnapViewController, animated: true)
```

```swift
//In same viewController must be implement delegate

//LFSSnapDelegate
//Each functions in LFSSnapDelegate is optional function

extension ViewController: LFSSnapDelegate {
//When edited video, boomerang and save button pressed.
//It will return saved path URL in camera roll
func snapVideo(whenSaved receiveURL: URL) {
print(receiveURL.absoluteString)
}

//When pressed next button after edited it will return URL of file
func snapVideo(whenNextAfterEdited receiveURL: URL) {
print(receiveURL.absoluteString)
}

//When edited photo, square photo and save button pressed.
//It will return UIImage
func snapPhoto(whenSaved receivePhoto: UIImage) {
print(receivePhoto)
}

//When pressed next button after edited it will return UIImage
func snapPhoto(whenNextAfterEdited receivePhoto: UIImage) {
print(receivePhoto)
}
}
```

## Contributing
Please open an issue first to discuss what you would like to change.

## License
Lifeup co., ltd
and Thank you GrowingTextView.

## Developer
Khwan Siricharoenporn (DEVG) (kosspeedgard@gmail.com)
