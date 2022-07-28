# GuruSwiftSDK

A Swift SDK for interacting with the Guru API.

# Getting Started

After adding the package as a dependency to your project, you will want to implement a controller like the following.
It is a simple controller that starts inference (in response to some button click) and shows each captured frame
to the user, in addition to rendering some of the inference result. Each section is described in more detail below.

```swift
import UIKit
import AVFoundation
import GuruSwiftSDK

class InferenceViewController: UIViewController {
  
  var inference: LocalVideoInference?
  @IBOutlet weak var imageView: UIImageView!
  var userLastFacing: UserFacing = UserFacing.other

  @IBAction func beingCapture(_ sender: AnyObject) {
    do {
        inference = try LocalVideoInference(
        consumer: self,
        cameraPosition: .front,
        source: "your-company-name",
        apiKey: "your-api-key"
      )
      
      Task {
        let videoId = try await inference!.start(activity: Activity.shoulder_flexion)
        print("Guru videoId is \(videoId)")
      }
    }
    catch {
      print("Unexpected error starting inference: \(error)")
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    Task {
      try! await inference?.stop()
    }
  }
}

extension InferenceViewController: InferenceConsumer {
  
  func consumeAnalysis(analysis: Analysis) {
    // TODO: Implement this function.
  }
  
  func consumeFrame(frame: UIImage, inference: FrameInference?) {
    if (inference != nil) {
      let painter = InferencePainter(frame: frame, inference: inference!)
        .paintLandmarkConnector(from: InferenceLandmark.leftShoulder, to: InferenceLandmark.leftElbow)
        .paintLandmarkConnector(from: InferenceLandmark.leftElbow, to: InferenceLandmark.leftWrist)
        .paintLandmarkConnector(from: InferenceLandmark.leftShoulder, to: InferenceLandmark.leftHip)
        .paintLandmarkConnector(from: InferenceLandmark.leftHip, to: InferenceLandmark.leftKnee)
        .paintLandmarkConnector(from: InferenceLandmark.leftKnee, to: InferenceLandmark.leftAnkle)
        .paintLandmarkConnector(from: InferenceLandmark.rightShoulder, to: InferenceLandmark.rightElbow)
        .paintLandmarkConnector(from: InferenceLandmark.rightElbow, to: InferenceLandmark.rightWrist)
        .paintLandmarkConnector(from: InferenceLandmark.rightShoulder, to: InferenceLandmark.rightHip)
        .paintLandmarkConnector(from: InferenceLandmark.rightHip, to: InferenceLandmark.rightKnee)
        .paintLandmarkConnector(from: InferenceLandmark.rightKnee, to: InferenceLandmark.rightAnkle)
      
      let userFacing = inference!.userFacing()
      if (userFacing != UserFacing.other) {
        userLastFacing = userFacing
      }
      if (userLastFacing == UserFacing.left) {
        painter.paintLandmarkAngle(center: InferenceLandmark.rightShoulder, from: InferenceLandmark.rightHip, to: InferenceLandmark.rightElbow, clockwise: true)
      }
      else if (userLastFacing == UserFacing.right) {
        painter.paintLandmarkAngle(center: InferenceLandmark.leftShoulder, from: InferenceLandmark.leftHip, to: InferenceLandmark.leftElbow, clockwise: false)
      }
      
      imageView.image = painter.finish()
    }
    else {
      imageView.image = frame
    }
  }
}
```

The member variables of the controller are:

```swift
var inference: LocalVideoInference?
```
The LocalVideoInference is the main engine for interacting with the GuruSwiftSDK. You will use it to start and stop the inference.

```swift
@IBOutlet weak var imageView: UIImageView!
```
A handle to a `UIImageView` that we'll use to display each captured frame.

```swift
var userLastFacing: UserFacing = UserFacing.other
```
A variable to store the direction the user was facing in the previous frame.
We'll use this below to help us in cases where the inference confidence is low.

The `beingCapture` method would be called in response to the user clicking a button to start capturing.
```swift
inference = try LocalVideoInference(
  consumer: self,
  cameraPosition: .front,
  source: "your-company-name",
  apiKey: "your-api-key"
)

Task {
  let videoId = try await inference!.start(activity: Activity.shoulder_flexion)
  print("Guru videoId is \(videoId)")
}
```
It takes the source and apiKey, that will have been provided to you by Guru.
You also specify which phone camera to use. 
The `consumer` is a reference to the object that will be called as inference is
performed. It must implement the `InferenceConsumer` protocol.
The call to `start` will open the camera and begin making callbacks to the consumer.

The `viewWillDisappear` method is called when the user navigates away. It
ensures that the video capturing stops using `try! await inference?.stop()`.

The `InferenceConsumer` implementation has 2 important methods:
`func consumeFrame(frame: UIImage, inference: FrameInference?)` will be called 
for each frame captured. It will include the `frame`, which is the raw image itself,
and the `inference`, which is the information that has been analysed for the frame.
You can combine the two to draw additional information on the screen about what has
been captured. In the example above, it is drawing some of the keypoints to
create a skeleton and the angle between the hip, shoulder, and elbow. See the method
documentation in `InferencePainter` for more detail on each method.

The `func consumeAnalysis(analysis: Analysis)` callback is invoked less frequently,
and contains meta analysis about each of the frames seen so far. In here you can find
information about reps that have been counted, and any extra information about those
reps.

# Development
## How to rebuild generated model classes
If a new VipnasEndToEnd.mlpackage is available, then from root of package:
```bash
xcrun coremlc compile VipnasEndToEnd.mlpackage .
xcrun coremlc generate VipnasEndToEnd.mlpackage . --language Swift
mv VipnasEndToEnd.mlmodelc Sources/GuruSwiftSDK
```

## How to run tests
The easiest way is to run them from the `Test navigator` in XCode.
