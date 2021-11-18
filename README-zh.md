#  涂鸦智慧社区 App SDK iOS 版示例

[中文文档](./README_zh.md) | [English](./README.md)

---

## 功能概述

涂鸦智慧社区 App SDK iOS 版是一套针对智慧社区提供的移动端开发工具。通过智慧社区 SDK，iOS 开发者可以基于 SDK 快速实现社区相关的 App 功能开发。

SDK 主要包括以下功能：

 - 用户管理
    + 支持用户的登录、注册等操作
    + 支持手机号码账号体系
    + 支持修改密码、账号注销等操作
    + 支持更新用户相关信息如昵称等
 - 房屋管理
    + 支持房屋的创建、更新、修改等操作
    + 支持获取房屋详情
    + 支持房间的创建、更新、修改等操作
    + 支持成员的创建、更新、修改等操作
 - 智能门禁
    + 支持远程开门 
    + 支持二维码及多种通行方式
 - 访客通行
    + 支持创建访客通行证、获取通行证信息等操作。
    + 支持获取访客事由列表、访客记录、删除邀请等操作。
 - 云可视对讲
    + 支持获取公区监控列表数据。
    + 支持可视对讲，开门、接听、挂断等操作。
    + 支持获取门禁列表数据。

## 要求

+ Xcode 12.0 and later
+ iOS 10 and later

## 使用示例

1. 涂鸦智慧社区SDK通过示例中的[CocoaPods](http://cocoapods.org/)。确保已经安装了CocoaPods。如果没有，请先运行以下命令安装CocoaPods。

   ```bash
   sudo gem install cocoapods
   pod setup
   ```

2. 克隆或下载本示例，将目录修改为包含**Podfile** 的目录，然后运行以下命令：

   ```bash
   pod update
   ```

3. 本示例需要您拥有在 [Tuya IoT 平台](https://developer.tuya.com/)上有一对秘钥和一张安全图片，如果没有，请注册一个开发者账号。然后执行以下步骤：
    1. 登录 [Tuya IoT 平台](https://iot.tuya.com/)。 在左侧导航栏中，选择 **App** > **SD​​K Development** > **智慧社区 App SDK**。
    2. 点击 **创建** 来创建一个应用程序.
    3. 填写所需信息，确保输入有效的 bundle ID，之后无法更改。
    4. 您可以在 **Obtain Key** 标签下找到 AppKey、AppSecret 和安全图片。

4. 打开 `TuyaCommunityKitSample.xcworkspace`。

5. 打开 `AppDelegate.m` 文件，在 `[AppDelegate application:didFinishLaunchingWithOptions:]` 方法中使用从开发平台获取的 `App Key` 和 `App Secret` 初始化 SDK：

   ```objective-c
   [[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
   ```

6. 下载安全镜像，重命名为 `t_s.bmp`，然后拖拽到工作区与 `Info.plist` 同级。

7. 如果你想在模拟器上调试它（在带有 M1 芯片的 Macbook 上），请在 Pods 项目中添加以下行。

    <img alt="Demo app" src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/16372061324e7800b9fc1.jpg" width="800">

> **注意**：bundle ID、AppKey、AppSecret、安全镜像必须与您在 [Tuya IoT 平台](https://iot.tuya.com) 上的应用一致。否则，示例无法请求 API。

## 参考

更多关于涂鸦智慧社区 App SDK iOS 版的信息，请参见 [IoT App SDK](https://developer.tuya.com/cn/docs/app-development/community?id=Kawmc4oea61ol)。
