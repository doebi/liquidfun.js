liquidfun.js
============

liquidfun.js is a direct port of the Liquidfun 2D physics engine to JavaScript, using Emscripten. I started this since the JavaScript Port of liquidfun provided by Google was incomplete and manually written. This project is translated directly to JavaScript, without human rewriting, so functionality should be identical to the original Liquidfun.

Building
========

* Install [Emscripten](https://github.com/kripken/emscripten)
* Clone this repo with it's submodules:
`git clone git@github.com:doebi/liquidfun.js.git --recursive`
* Compile it using emscripten:
`emmake make`

Usage
=====

There are some slight differences in Usage compared to the manual emscripten port provided by Google.<br>
*more details coming ~~soon~~*

Thanks
======

* erincatto for [Box2D](https://github.com/erincatto/box2d)
* google for [Liquidfun](https://github.com/google/liquidfun)
* kripken for [Emscripten](https://github.com/kripken/emscripten)
