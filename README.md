<img src="https://github.com/Jsmith4523/Pantry-2023-Swift-Student-Challenge-Submission-/blob/main/Pantry%20GitHub%20.jpg?raw=true">

# Pantry 

My 2023 Swift Student Challenge Project is called 'Pantry'. In this project, I focused on reducing food waste, costly expenses, and managing in-house kitchen inventory through likes of scanning UPC barcodes and machine learning using an iPhone's camera. 

When scanning the UPC barcode of certain store merchandise, the application first detects if it has an item that matches the same UPC, and allows the user to edit information for the merchandise. Pantry includes an object detection machine learning model that can detect certain fruits and vegetables, which also detects if the item is already added to thier pantry. If the app does not already have the item, a user can enter additional information about the merchandise, such as the quantity, catergory, price, expiration date, and more. Once an item is added, Pantry automatically organizes merchandise that is safe to eat, near expiration, or have expired.

Items that are near their set expiration date are sectioned away from other merchandise in the pantry. Automatically, pantry sets a '4 days before' expiration date setting on merchandise. This can be changed within the settings of the application. If an item has expired, the item is no longer safe to eat and the user has the immediate option to 'Throw away' the item, or update the information for that item. 

If Pantry detects that an item is low or out of stock, the user is directly notified in their pantry.

# What I learned!
* How to create image annotations and feed the information to a CoreML object detection model.
* Understanding the importance of a testing machine learning model.
* How a Swift Playground App project works and how it differs from an Xcode project.
* Proper code reusability.
* Date formatting.
* Properly using AVFoundation with CoreML and extrating live image data
* Checking if a AVCaptureDevice has certain abilities such as torch or image capture.
* Threads.

# Technology used
* SwiftUI and UIKit
* AVFoundation
* Vision
* CreateML
* CoreML
