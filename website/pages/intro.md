# 1. Introduction
This guide will walk you through the basic concepts behind Fron. Fron is a library
for creating dynamic **composeable user interfaces** with Ruby (through Opal).

## Features
* **Custom components** that can be extended and composed
* **Behaviors** to specify how components behave
* **Utilities** such as **Request**, **Shortcuts** or **Drag & Drop**
* **Testable** with **RSpec**
* **Test Coverage** can be reported accurately (with source maps)

## Resources
* Source Code: [https://github.com/digitalnatives/fron](https://github.com/digitalnatives/fron)
* Yard Documentation: [http://www.rubydoc.info/github/digitalnatives/fron/master](http://www.rubydoc.info/github/digitalnatives/fron/master)
* Gitter: [https://gitter.im/digitalnatives/fron](https://gitter.im/digitalnatives/fron)
* Wiki: [https://github.com/digitalnatives/fron/wiki](https://github.com/digitalnatives/fron/wiki)

## Why Ruby?
We chose ruby for these awesome features:
* It is a **mature language** (20 years)
* A **coding style guide** is already present
* **Testing** is and always have been a core part (Rspec)
* The **tooling** is great (Rubycritic, Rubocop, Sprockets just to name a few)

## How it is different from [Volt](http://voltframework.com/) or [Vienna](https://github.com/opal/vienna)?
Both of those frameworks apply the same logic that has been used to create web sites for decades, namely the MVC pattern and templates, also they are not using the DOM
in a Rubyesque way, they treat the frontend as you would in a Rails application.

Fron is different because it is not trying to be a full featured web application, it is just the **fron(tend) part** in **Ruby**.

## It is used in production?
Currently we use it in production in one of our inhouse products [Nostromo](https://nostromo.io).
