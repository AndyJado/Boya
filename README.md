# 伯牙 (Not the offical Readme)

**Another note taking app we don't need, but maybe..**

https://user-images.githubusercontent.com/101876416/174430588-d52fd3e1-eb7e-4165-8398-d08a42a9165e.mov



Citizen for the app is, the record of the minimal life span one can proceed, which in my proposal, is made of 1 String and 2 Int:
the word you say, life you spend, and time you repeat.

```swift
struct Aword:Hashable, Codable {
    var text: String = ""
    var secondSpent: Int = 0
    var edition: Int = 1
}
```
And all functionality along is there to make the citizen well accommodated.
