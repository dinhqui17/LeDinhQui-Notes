# LeDinhQui-Notes
Stay organized and boost your productivity with LDQ Notes, the ultimate digital notebook designed for everyone.

# Screenshot
![alt text](https://github.com/dinhqui17/LeDinhQui-Notes/blob/main/screenshot.jpg)

# App Functions
+ Users can register and log in using their username.
+ Users can save notes to the Firebase database.
+ Users can view a list of their saved notes.
+ Users can view notes from other users, but cannot edit them.

# Time spent: 25 hours
+ View, analyze bussiness requirement, plan layout and screen ideas  (~ 3h)
+ Set up Firebase Realtime DB (~ 2h)
+ LoginScreen (~ 6h)
+ UserListScreen (~ 3h)
+ MyNoteScreen and NoteFromOther (~ 3h)
+ NoteDetailScreen (~ 4h)
+ Optimize, refactor code (~ 2h)
+ Write readme (~ 2h)

# Solutions

After receiving the assignment, I analyzed the requirements and then came up with ideas for the screens and layout of each screen to meet the criteria:
+ Simple
+ Modern interface,
+ Easy to use
+ Can take notes in the fastest time.

As for the technology, I chose to use the SwiftUI framework instead of the traditional UIKit framework, because SwiftUI can create interfaces quickly with less code, and it supports state management methods instead of management. manual state when using UIKit. According to some comparisons, the performance of SwiftUI will be higher than that of UIKit. For the design pattern, I embraced MVVM to segregate logic from the user interface, fostering better organization and maintainability. Incorporating the Combine framework enables seamless handling of asynchronous events, such as network requests and retrieval of user and note lists. I use Firebase Realtime Database as a data storage solution because it supports real-time, easy integration, and ease of use.

# Limitations of the solution
+ Firebase Realtime Database Limitations:
  + Database is organized as trees, parent-children, not Table, so those who are familiar with SQL may have difficulty.
  + Does not support complex data queries. For example, you cannot perform SQL-like queries such as JOINs.
  + Cannot be used offline, better to use Realm DB, CoreData or some solution to store offline and sync data with Firebase Realtime Database.
  + Firebase Realtime Database has limitations on data size. Each database can only store up to 1GB of data.
  + While Firebase Realtime Database offers a certain amount of data for free, if you need to store or transmit large amounts of data, the cost can increase significantly.
  + Firebase Realtime Database does not support full-text search, which can make finding specific data in the database challenging.
 
+ MVVM Limitations:
  + In large applications, ViewModels can become complex and difficult to manage. Managing a large number of ViewModel objects can clutter the codebase and make it hard to maintain.
  + In some cases, managing routing and navigation can be more complex in MVVM.
  + In some cases, using MVVM can decrease the performance of an application because adding intermediary layers like ViewModels can increase startup time and memory usage.
 
+ App Functions:
  + Viewing other user's notes does not seem to comply with privacy. I limited it by not allowing editing.
  + checkExistUser(): Client side check is not a secure solution. Better to use Cloud Functions for Firebase for it.
