# SVNetworking
---

SVNetworking is a library for networking and resource loading in iOS applications. It is primarily designed for use with key-value observing, and attempts to make use of functional concepts when possible. To aid in this, implementations of property binding and some higher-order functions are included.

## Requests
Requests are handled by a subclasses of `SVRequest`. These are fairly simple classes - SVNetworking is generally lightweight, and tries to solve most problems while maintaining elegance, instead of solving all possible problems.

`SVRequest` uses delegation instead of completion/failure blocks - while this often results in slightly more code, it avoids retain cycles, "`weakSelf`", and nested "callback hell".

While the request classes were originally the entirety of SVNetworking, the focus of the library is now on resource loading.

## Remote Resources
The abstract class `SVRemoteResource` provides a base for implementations of resources that are loaded asynchronously. `SVRemoteResource` has no coupling with `SVRequest` or network requests in general (although some subclasses do) - it can be easily used with any other networking library, or with any other asynchronous process with an end result. For example:

* Loading large files from disk
* Procedural generation
* Video processing

Resources are generally uniqued for memory benefits (among others), but this is optional.

Remote resources are intended for use with key-value observing. The binding categories on `NSObject` and the `SV_KEYPATH` macro are intended to aid in this.

## Documentation
SVNetworking is fully documented with [appledoc](http://gentlebytes.com/appledoc/), which can be easily installed:

    brew install appledoc

Once `appledoc` is installed, use the scripts in the `Documentation` directory to generate documentation.