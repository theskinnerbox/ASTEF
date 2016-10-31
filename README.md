# ASTEF: A Simple Tool for Examining Fixations.

Official website: http://astef.info

## Overview
A Simple Tool for Examining Fixations (ASTEF) is a project for facilitating the use of spatial statistics on eye tracking data. The first version of the software was developed in C# and it is no longer maintained. This version is coded for Matlab. The interface has completely redesigned and simplified.

## Fixation Data Format
Fixation file has to be a simple text file, .txt extension, space-delimited.

First line: screen width and height, in pixel.

From second line to the end: timestamp, in milliseconds, and x y coordinates of each fixation, in pixels.

Example:
```
1024 768
1083 369 482
1684 388 546
1856 359 589
2264 337 684
3212 340 854
3576 380 433
```
## Screenshots

![Screenshot](ASTEF-load.png)

## Available programming languages

Current:
* Matlab

Planned:
* Current web browsers are capable of supporting sites that are indistinguishable from computer applications. Although many everyday tasks like word processing and photo editing can now be carried out on-line, scientific web apps for data analysis are very rare. That is very unfortunate because researchers often need to purchase, install, and learn very complicated packages even if they only need a few of their functionalities. In the future we want to introduce a website developed for examining eye-tracking data and readily computing few critical indices. That would represent an evolution of both the package that was introduced several years ago and the current one. So far, ASTEF users were mainly interested in the NNI computing function and often requested versions for other operating systems. With that in mind, our efforts will be devoted to developing a site providing only the core functions of ASTEF, thus making it platform-independent and motivating users to request additional features that best suit their research and data visualization needs. A first implementation by Francesco Malatesta (https://github.com/francescomalatesta) was provided (see the Pull requests).

If you want to contribute to the web application, porting ASTEF to other programming languages, or improving the existing versions, please contact us!

## Publications
* Di Nocera, F., Capobianco, C., & Mastrangelo, S. (2016). [A Simple(r) Tool For Examining Fixations.][df1] Journal of Eye Movement Research, 9(4):3:1-6
* Camilli, M., Nacchia, R., Terenzi, M., & Di Nocera, F. (2008). [ASTEF: A Simple Tool for Examining Fixations.][df2] Behavior Research Methods, 40(2), 373-382.
* Camilli, M., & Di Nocera, F. (2007). [Visualizzare, gestire e analizzare le fissazioni oculari. Semplicemente con un click?][df3] Ergonomia, 7/8, 21-25.
* Di Nocera, F., Camilli, M., & Terenzi, M. (2007). [A random glance at the flight deck: pilot’s scanning strategies and the real-time assessment of mental workload.][df3] Journal of Cognitive Engineering and Decision Making, 1(3), 271-285.

[df1]: https://bop.unibe.ch/index.php/JEMR/article/view/2477/pdf_943
[df2]: http://link.springer.com/content/pdf/10.3758/BRM.40.2.373.pdf
[df3]: https://drive.google.com/open?id=0B7AUqNOamccSemdBY3FudTNBMm8
[df4]: http://edm.sagepub.com/content/1/3/271.full.pdf
