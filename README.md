# CircuitT monad

Lets you circuit your computations. For example:

```haskell
lazyAfternoon :: Int -> IO ()
lazyAfternoon hours = runCircuitT $ do
    readMailingLists
    readReddit
    when (hours > 12)
        (escape ())
    sendEmails
    fixBugs
```

Think of `escape` as of `return` from other languages.
