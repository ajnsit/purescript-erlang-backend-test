module Main where

import Control.Bind (bind, discard)
import Data.Function (($))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Class.Console (log)
import Erl.Process (SpawnedProcessState, spawn, (!))

data Doer a = Doer (SpawnedProcessState (Doer a) -> Effect a)

doer :: forall a. String -> Doer a
doer s = Doer \recv -> do
  log s
  next <- recv.receive
  doit next recv

doit :: forall a. Doer a -> SpawnedProcessState (Doer a) -> Effect a
doit (Doer f) = f

main :: Effect Unit
main = do
  p <- spawn $ doit $ doer "starting"
  p ! doer "UN"
  p ! doer "DOS"
  p ! doer "TRES"
