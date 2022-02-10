---
layout: news_item
title: "Ion Hash-js 2.0.0 Released"
date: 2020-03-31
categories: news 
---

### API Changes
* Adds `digest()`, which provides a streamlined API for calculating an Ion hash of any value, including native JavaScript types as well as instances of ion-js 4.0's [`dom.Value`](https://github.com/amzn/ion-js/releases/tag/v4.0.0) class.
  * Calculate the Ion hash of a JS native value using the 'md5' hash function:
    ```javascript
    let digest = ionHash.digest([1, 2, 3], 'md5');
    ```
  * Calculate the same Ion hash as above using an instance of `dom.Value`:
    ```javascript
    let digest = ionHash.digest(ion.dom.load('[1, 2, 3]'), 'md5');
    ```
* ion-js and jsbi are now declared as peer dependencies; in addition to depending on ion-hash-js, consumers are now required to declare ion-js and jsbi as dependencies.
* Renamed `cryptoIonHasherProvider()` to `cryptoHasherProvider()`.

Associated milestone:  [M2](https://github.com/amzn/ion-hash-js/milestone/2)

Full list of changes: [v1.0.3...v2.0.0](https://github.com/amzn/ion-hash-js/compare/v1.0.3...v2.0.0)

| [Release Notes v2.0.0](https://github.com/amzn//releases/tag/v2.0.0) | [Ion Hash-js](https://github.com/amzn/ion-hash-js) |

