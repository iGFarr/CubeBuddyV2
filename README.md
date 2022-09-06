<div>
  <h1>CubeBuddyV2</h1>
  <h2>**NOW SUPPORTING MOST LANGUAGES**</h2>
</div>
<p> This is a rework of my original cube timer, which was made primarily with Storyboard IB. In this version which uses no storyboards at all, I use a custom Cube class(an extension of Kaz Yoshikawa's Cube class - /Models/Functional/CoreRubiksCube.swift). I added a function to map each face to a color in order to create a flat graphical representation of the cube which can be manipulated via buttons on the side of each face. I also added a function to convert a string to a move list and then return the mutated Cube object. Initially, I was storing solves in User Defaults to get up and running, but the application is now converted to use Core Data instead. In V1, I used Realm, but this made the application too heavy for regular size GitHub repos!</p>
<hr size="5">
<p float="left">
  <img src="AppDemoGIF1.gif" width="400" />
  <img src="AppDemoGIF2V2.gif" width="400" height="845" /> 
</p>
<hr size="5">
<div class="column" style="background-color:#FFB695;">
  <p>Dark Theme</p>
  <img src="AppDemo-1.png" width="800" />
</div>
<div class="column" style="background-color:#96D1CD;">
  <p>Light Theme</p>
  <img src="AppDemo-2.png" width="800" />
</div>
<hr size="5">
<img src="AppDemo-3.png" width="800" />
<hr size="5">
<img src="AppDemo-4.png" width="800" />
<hr size="5">
<img src="AppDemo-5.png" width="800" />
<hr size="5">
<img src="AppDemo-6.png" width="800" />
