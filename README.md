# iOS- Marvel API

## Description

It is a demo application that communicates with the marvel API at developer.marvel.com. The application shows a list 
of comics and allows you to access the detail of each one by selecting it. It also allows you to add favorite
 characters that are stored in the device's local database


## How to Build
1. Prepare API authentication

      - Copy iOS-Marvel/apikeys_template.plist to iOS-Marvel/apikeys.plist
      - Add your public and private keys to apikeys.plist

2. The app is using Carthage as dependency manager so you will need to run at the root directory of your project:
```sh
$ carthage update --platform iOS
```

