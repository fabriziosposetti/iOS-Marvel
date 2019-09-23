# iOS- Marvel API

## Description

It is a demo application that communicates with the marvel API at developer.marvel.com. The application shows a list 
of comics and allows you to access the detail of each one by selecting it. It also allows you to add favorite
 characters that are stored in the device's local database. Apart from that, you can filter the characters by name.


## Generate your Marvel API keys

1. Create an account at http://developer.marvel.com

2. After confirming your account, click on the "Get A Key" tab and accept the terms and conditions. You should now see your private and public key.

3. Copy the public key and paste it into the publicKey section of the apikeys.plist file. Do the same for your private key.



## How to Build
1. Prepare API authentication

      - Copy iOS-Marvel/apikeys_template.plist to iOS-Marvel/apikeys.plist
      - Add your public and private keys to apikeys.plist

2. The app is using Carthage as dependency manager so you will need to run at the root directory of your project:
```sh
$ carthage update --platform iOS
```
Alamofire - HTTP networking library for API calls

Kingfisher - HTTP networking library for easy downloading of images asynchronously

Realm - Local device data base
