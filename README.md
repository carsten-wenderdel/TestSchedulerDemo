# TestSchedulerDemo

This repository contains demonstration code for my Medium article [iOS Unit Tests and Asynchronous Calls](https://medium.com/mobimeo-technology/ios-unit-tests-and-asynchronous-calls-a8787b44d817).

A simple class `Delayer` using `DispatchQueue.main.asyncAfter` is refactored to allow better unit testing.

The refactoring is done twice, first with `ReactiveSwift`, second with `Combine`. The `ReactiveSwift` part uses a global variable to access the `TestScheduler`, the `Combine` part uses _Constructor Injection_.
