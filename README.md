# neon3

trimServiceするから、trimする時間(サンプルの時間の)

## 参考
### riverpod+camera
[【Flutter】Cameraライブラリを使用してインカメラ（内カメ）で写真を撮影する方法](https://qiita.com/pikatyu3/items/fedfa27ab889b0d07b37)

[【Flutter】cameraパッケージの基本とTips](https://docs.sakai-sc.co.jp/article/programing/flutter-camera-package.html)

### stateNotifierProviderでonDisposeを使う
[FlutterでQRコードを読み込む（riverpod 2)](https://qiita.com/t-yasukawa/items/897b1114b228844bf324)


### 参考
https://zenn.dev/mkikuchi/articles/cc87c84e1404c4
↑providerで囲ってredirectさせるとき、`  routeInformationParser: router.routeInformationParser,routerDelegate: router.routerDelegate,`じゃなくてrouterConfig: router,でやらないと動かない、
https://github.com/flutter/flutter/issues/112915

match_review_pageでhookConsumerWidgetで_watchMethod()でConsumer使ってる
hooksはレンダリングしたあとに行われる
