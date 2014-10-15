module Main where

import           Control.Monad.Trans.CircuitT
import           Test.Tasty
import           Test.Tasty.QuickCheck        as QC
import           Control.Monad.Identity       (Identity)

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" [properties]

properties :: TestTree
properties = testGroup "Properties" [qcProps]

qcProps :: TestTree
qcProps = testGroup "(checked by QuickCheck)"
  [ QC.testProperty "runCircuitT (return x) == x" $
      \x -> runCircuitT (return x) == (return x :: Identity Int)
  , QC.testProperty "runCircuitT (return x >> escape y >> return z) == y" $
      \x y z -> runCircuitT (return (x::Int) >>
                             escape (y::Int) >>
                             return (z::Int))
                == (return y :: Identity Int)
  , QC.testProperty "runCircuitT (return x >> return y >> return z) == y" $
      \x y z -> runCircuitT (return (x::Int)
                             >> return (y::Int)
                             >> return (z::Int))
                == (return z :: Identity Int)
  ]
