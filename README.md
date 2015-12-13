# Flite Engine
The FliteEngine is Objective-C static library project containing light wrapper for [Flite](http://www.speech.cs.cmu.edu/flite/) open source speech synthesizer.

It does not add any new features to Flite, it only exposes its funcionality as Objective-C class methods and combines this functionality with iOS _AVFoundation Framework_

## Introduction
A few years ago I was looking for some Objective-C framework which would allow to speech text on iOS devices in our project. In that time i did not find any, but only tree plain speech synth libraries written i C - eSpeak, Flite and Festival. After couple days of research and attempts to integrate those libraries for iOS SDK I choosed eSpeak and Flite as candidates (I was able to successfully customize only eSpeak and Flite in reasonable time, they supports more languages, Google use eSpeek for its translation service…).

In next couple of lines is described Flite speech synthesizer wrapper - FliteEngine.

## Details
The FliteEngine is Objectice-C static library project containing very light wrapper for Flite open source speech synthesizer (based on release version 1.4). It does not add any new features to Flite, it only exposes a part of its funcionality as Objective-C class methods and combines this functionality with iOS _AVFoundation Framework_ (to see all available properties of Flite synthesizer, please read documentation on its homepage url). It also uses standard delegate pattern by defining FliteEngineDelegate?. 
In static library project also exists a test target which contains simple iPhone app. This sample app has only a one screen with the _UITextView_ for text input and the _UIButton_ to start speech syntesis of an entered text.

### Usage
Usage of the FliteEngine is very easy, You have to only add:
* Dependency on the _FliteEngine_ static library project to Your project 
* Add path to folder _Flite_1_0/Classes_ in Target Build Settings: _Header Search Paths_

Then import the FliteEngine? header in class which is holding engine instance:
```objc
#import "FliteEngine.h"
```
In the init or the viewDidLoad method create a new instance of the FliteEngine? and set all parameters you want (speed, variance, pitch):
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    engine = [[FliteEngine alloc] init];
    engine.volume = 1;
} 
```
And finally bind any button's touch event to code which calls the FliteEngine? a speak method:
```objc
- (IBAction)speech {
    NSString * text = self.textView.text;
    [engine speak:text];
}
```
No documentation is included in this up-to-date version. Anyhow, the source code is self-explanatory and has altogether only a few hundred lines, also test application is good start point to look for more properties.

Any questions will be answered, feel free to contact me.
