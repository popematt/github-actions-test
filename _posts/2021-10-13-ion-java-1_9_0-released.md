---
layout: news_item
title: "Ion Java 1.9.0 Released"
date: 2021-10-13
categories: news 
---

### Features
* Added a new binary reader implementation that speeds up reads by up to 50% and allows for data to be parsed incrementally from a growing InputStream. To enable the new reader implementation, use `IonReaderBuilder.withIncrementalReadingEnabled`. (#355)
* Added an `IonSystemBuilder` option (`IonSystemBuilder.withReaderBuilder`) that allows users to specify an `IonReaderBuilder` to be used to construct any `IonReaders` needed by `IonSystem`’s methods (`newReader`, `iterate`, `singleValue`, and `IonLoader.load` via `IonSystem.getLoader` or `IonSystem.newLoader`). This may be used, for example, to use the new incremental binary reader to read binary Ion data into its `IonValue` representation. (#385)

### Fixes
* Added a pool of reusable UTF-8 decoders to be used by both binary reader implementations, making repetitive instantiation less expensive. (#388)
* Eliminated the use of `ConcurrentLinkedQueue.size()` in the binary writer’s block pool, improving writer performance when the pool gets large. (#389)

List of commits: [v1.8.3...v1.9.0](https://github.com/amzn/ion-java/compare/v1.8.3...v1.9.0)

| [Release Notes v1.9.0](https://github.com/amzn//releases/tag/v1.9.0) | [Ion Java](https://github.com/amzn/ion-java) |

