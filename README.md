## Welcome to the Graphing Calculator App for iPhone & iPad!

This repo contains the source code for a Universal App for iPhone & iPad named "**Calculator**", which is my work on [Assignment 3](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071#).

I've developed it as member of the [Stanford University](http://www.stanford.edu) class "Coding together-Apps for iPhone & iPad" (CS193p). This class has been setup by Standford University in summer 2012 as an online peer collaboration community on [piazza.com](http://www.piazza.com). Moderated by instructors, members can communicate about iOS development issues in order to finish their given assignments.

The Coding-together class is based on lectures [Developing Apps for iOS (CS193P)](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071) from Prof. Paul Hegarty, that are distributed online via iTunes U.

## App features

![image](http://www.arnobost.de/SiteImages/2012-07-24-Calc-iPhone-Portrait-01.png)
![image](http://www.arnobost.de/SiteImages/2012-07-24-Calc-iPhone-Portrait-02.png)
![image](http://www.arnobost.de/SiteImages/2012-07-24-Calc-iPhone-Landscape.png)
![image](http://www.arnobost.de/SiteImages/2012-07-24-Calc-iPad-Landscape.png)

The requested features for the App are defined in the class's [Assignments 1 to 3](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071#). There are mandatory and optional requests, that give extra credits in the "real world".

The task is to develop a Universal app for iPhone & iPad (>= iOS 5.x), that works as a **RPN-Calculator**. "RPN" stands for "Reverse Polish notation". This is some old-fashioned stuff of the early days of digital calculators (-> [Wikipedia article](http://en.wikipedia.org/wiki/Reverse_Polish_notation)). Additionally to calculate with numbers the user may enter a variable "x" and gets a visualization of the resulting function graph.

## Features for Assignment 3 (Graphing Calculator)

Assignment 3 is based on the previous Assignment 2. When starting my work on Assignment 3, I decided to strip away the code lines, which enabled rotation for the calculator, which I added as an extra feature on my own before.

These new **features** are added for Assignment 3:

* enhance the iPhone-only calculator by iPad-support as a **Universal App**.
* new **Graph Button** to display the function graph of the current program.
* **removed**: test buttons and variable buttons for "a" and "b".
* **removed**: variable display.
* new rotable **Function Graph View**, which is reusable by design.
* enable **Pan Gesture** to let the user move the Function Graph over the screen.
* enable **Triple Tap Gesture** to let the user define a new origin for the axes on the screen.
* enable **Pinch Gesture** to let a user upscale and downscale the Function Graph.
* enable **Persistant Defaults** for scale and origin.
* enable a **Split View** on the iPad with the Calculator on the left and the Function Graph on the right hand side.
* enable a **Flexible Screen Handling** on the iPad in Portrait orientation: provide a full screen Function Graph view and allow the User, to pop over the Calculator view by a push button.

**Extra Credits:**

* implement **Pixel Level Graphing** in a "dot mode" for best results on a retina display.
* optimize **Line Drawing Mode** with regards to avoid inproper results, e.g. when x=0 in function "1/x"
* implement a **UISwitch** in the Graph View to let the user toggle betwwen Pixel Mode Drawing and Line Mode Drawing. (In Pixel Mode Drawing, for each horizontal pixel-value the corresponding y-pixel-value is calculated and drawn. In Line Mode Drawing, these pixels get connected to a line (or to some lines)).
* improve the **Performance of Panning**.

**Additional features on my own:**

* for **proper use of the (small) display** space, I injected the string, which describes the current Function Graph, into the center of the top bar (both on iPhone and iPad) instead somewhere else on display.
* I **optimized performance for any gestures** with a kind of "intelligent caching": when a user pinches, pans or triple-taps, the movement on the display is drawn very fast. (In the first version, it really was not smoothly.) The Function Graph changes it's color to gray, while a gesture is ongoing, and moves the portion of the formerly calculated x-y-pairs. Only when the gesture did end, the whole Function Graph gets recalculated and drawn in blue color.



## Features for Assignment 2 (Programmable Calculator)

The source code for the Assignments 2 and 1 can be found here: [link](https://github.com/ArnoBost/Calculator-for-iOS)

Assignment 2 is based on the code for Assignment 1.
I've added these **features** in accordance with Assignment 1:

* enhance the calculator to be **programmable**.
* new **variable buttons** for entering variables named "x", "a" and "b".
* new **test buttons** for applying (hard coded) values to the variables.
* new **variable display** in the view to display the variable with values, which are used in the current program.
* changed the **history label** to show the program entered by a user in a more convenient way with outbreaking minimization of the use of parentheses.
* new **undo button** as an enhancement to the formerly backspace button: when there is no last digit to be deleted, the user can delete the last operation or operand from the program stack.

**Extra Credit:**
* enhanced **error handling**: now displaying an error message instead of a Zero-Number, when an error occured during run of the program (e.g. division by zero). 
* It's a great enhancement of user experience, especially in combination with the new **undo feature** (see above).

**Additional features on my own:**

* **tweaked buttons** to be more userfriendly (only in the view, history display remains unchanged).
* new **logo images** for app.
* new **golden background image** for the main calculator view.
* new **1/x button** delivers functionality to calculate reversal numbers.
* enhanced **error handling** by displaying a smiley in the history label, when an operand was missed by the last operation (instead of the formerly "0" in this situation).
* major feature: **support for device rotation** is added including a new view for landscape mode, done by major improvements in Storyboard and CalculatorView.m.


## Features for Assignment 1 (RPN-Calculator)

I've implemented all of those **features**, e.g.:

* a **history label**, that displays the operands and operations pushed onto the calculator stack. A "="-character indicates, that the main display is representing the result of an operation.
* provide **digit buttons** for the user input of numbers.
* provide an **enter button** to push the current display number onto the calculator stack.
* provide **operation buttons** to let the user perform math operations (+, -, /, *).
* provide **additional operation buttons** like sin, cos, log, √, x²
* provide **period button** and handle input of decimal delimiter properly.
* provide **+/- button** to change the leading sign. If user is entering a number, switch the sign of the main display. Else handle it like an operator, to math the last operation's result by * (-1).
* provide **π button** to enter Pi and push it onto the calculator stack.
* **rror handling** has to be done not by an error indicator, but by delivering "0" as an operation's result, e.g. when division "/0" gets calculated.
* **backspace button** to delete the last digit of a number, that the user currently is entering.

**Additional features on my own:**

* provide **logo image** for app.
* provide **image backgrounds** for buttons and history/main display label.


## Remarks

History:
* Assignment 1: "RPN-Calculator"
* Assignment 2: "Programmable Calculator"
* Assignment 3: "Universal App"
