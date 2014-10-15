-- | Monadic computations in which you need to be able to
-- short-circuit, in analogy "return" from "classic" programming languages

{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Control.Monad.Trans.CircuitT
  ( CircuitT
  , escape
  , runCircuitT
  )
where

import           Control.Applicative
import           Control.Monad.Trans.Either

type CircuitT m a = CircuitTW a m a

newtype CircuitTW e m a = CircuitTW (EitherT e m a)
    deriving (Functor, Applicative, Monad)

escape :: Monad m => a -> CircuitT m a
escape a = (CircuitTW . EitherT . return . Left) a

runCircuitT :: Functor m => CircuitT m a -> m a
runCircuitT (CircuitTW e) = unEither <$> runEitherT e

unEither :: Either a a -> a
unEither (Left a) = a
unEither (Right a) = a
