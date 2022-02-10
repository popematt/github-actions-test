---
layout: news_item
title: "Ion Hash-dotnet 1.0.0 Released"
date: 2020-06-03
categories: news 
---

This release provides full support for hashing all Ion values.

## Changes
* Now depends on ion-dotnet v1.0.0
* `IIonHashReader` inherits breaking interface changes to `IIonReader` made in [ion-dotnet v1.0.0](https://github.com/amzn/ion-dotnet/releases).  Specifically: `GetTypeAnnotations()` now returns `string[]`. The new `GetTypeAnnotationSymbols()` API provides the same functionality that `GetTypeAnnotations()` previously provided.
* Adds API documentation (#37) 

## Bug Fixes
* Removes logic that was causing annotations to be duplicated during hashing (#28) 

Associated milestone:  [M2](https://github.com/amzn/ion-hash-dotnet/milestone/1)

Full list of commits:  https://github.com/amzn/ion-hash-dotnet/compare/v0.9.0-beta...v1.0.0

| [Release Notes v1.0.0](https://github.com/amzn//releases/tag/v1.0.0) | [Ion Hash-dotnet](https://github.com/amzn/ion-hash-dotnet) |

