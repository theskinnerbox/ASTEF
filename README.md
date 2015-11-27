# ASTEF: a simple tool for examining fixations.

Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco, LAFC 2015

Official website: http://theskinnerbox.net/astef/

## Overview
ASTEF is a tool for ocular fixations visualization and analysis. In particular, this tool computes and plots the NNI (Nearest Neighbor Index).
## Fixation Data Format
Fixation file has to be a text file with .txt.

First line: screen width and height, in pixel.

Second line: *"Timestamp Fix_x Fix_y"*.

From third line to the end: timestamp x y

Data is separated by white spaces.

Example:
```
1024 1024
Timestamp Fix_x Fix_y
1083 369 482
1684 388 546
1856 359 589
2264 337 684
3212 340 854
3576 380 433
```

## Available programming languages

Current:
* Matlab

Planned:
* C#
* node.js

If you want to contribute to port astef in new languages, or improve the existing versions, please contact us!

## Publications
* A description of the first version of this app can be found in Camilli, M., Nacchia, R., Terenzi, M., & Di Nocera, F. (2008). ASTEF: A Simple Tool for Examining Fixations. Behavior Research Methods, 40(2), 373-382.
* A description of the approach we used for assessing mental workload can be found in Di Nocera, F., Camilli, M., & Terenzi, M. (2007). A random glance at the flight deck: pilot’s scanning strategies and the real-time assessment of mental workload. Journal of Cognitive Engineering and Decision Making, 1(3), 271-285.
