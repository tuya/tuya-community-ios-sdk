# Smart Community App SDK Sample for iOS

[English](README.md) | [中文版](README-zh.md)

---

## Overview

Tuya **Smart Community App  SDK for iOS** is used to develop mobile apps for Smart Community PaaS. Based on the SDK, you can quickly implement app functionality during app development on iOS.

The SDK supports the following features:

+ User management
    - Log in and register users
    - Register users with mobile phone numbers
    - Change passwords and sign out of accounts
    - Update user information, such as nicknames
+ House management
    - Create, update, and modify houses
    - Get house details
    - Create, update, and modify rooms
    - Create, update, and modify members
+ Smart access control
    - Remotely unlock doors
    - Implement access control by means such as QR code scanning.
+ Guest access control
    - Create guest passes and get pass information
    - Get visit reasons and guest records, and delete invitations
+ Cloud-based video talk
    - Get monitoring data of public areas
    - Conduct video talk, unlock doors, answer doorbells, and hang up
    - Get a list of access control data

**Demo app**:

<img alt="Demo app" src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/1637202663f496fb84672.png" width="400">

## Prerequisites

+ Xcode 12.0 and later
+ iOS 10 and later

## Use the sample

1. The Tuya Smart Community SDK is distributed through [CocoaPods](http://cocoapods.org/) and other dependencies in this sample. Make sure that you have installed CocoaPods. If not, run the following command to install CocoaPods first:

    ```bash
    sudo gem install cocoapods
    pod setup
    ```

2. Clone or download this sample, change the directory to the one that includes **Podfile**, and then run the following command:

    ```bash
    pod update
    ```

3. This sample requires you to have a pair of keys and a security image from [Tuya IoT Development Platform](https://developer.tuya.com/), and register a developer account if you do not have one. Then, perform the following steps:

   1. Log in to the [Tuya IoT Development Platform](https://iot.tuya.com/). In the left-side navigation pane, choose **App** > **SDK Development**  > **Smart Community App SDK**.

   2. Click **Create** to create an app.

   3. Fill in the required information. Make sure that you enter the valid Bundle ID. It cannot be changed afterward.

   4. You can find the AppKey, AppSecret, and security image under the **Obtain Key** tag.

4. Open the `TuyaCommunityKitSample.xcworkspace` pod generated for you.

5. Open the file `AppDelegate.m` and use the `App ID` and `App Secret` that are obtained from the development platform in the method `[AppDelegate application:didFinishLaunchingWithOptions:]` to initialize the SDK:

    ```objective-c
    [[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
    ```

6. Download the security image, rename it to `t_s.bmp`, and then drag it to the workspace to be at the same level as `Info.plist`.

7. To debug the sample by using the simulator built on a MacBook with the M1 chip, add the following line on the Pods project.

    <img alt="Demo app" src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/16372061324e7800b9fc1.jpg" width="800">

> **Note**: The bundle ID, AppKey, AppSecret, and security image must be consistent with those used on the [Tuya IoT Development Platform](https://iot.tuya.com). Otherwise, any mismatch will cause API requests to fail.

## References
For more information about Smart Community App SDK for iOS, see [IoT App SDK](https://developer.tuya.com/cn/docs/app-development/community?id=Kawmc4oea61ol).
