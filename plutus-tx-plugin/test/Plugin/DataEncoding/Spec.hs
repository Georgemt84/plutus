-- editorconfig-checker-disable-file
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE NegativeLiterals #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# OPTIONS_GHC -fno-omit-interface-pragmas #-}
{-# OPTIONS_GHC -fplugin PlutusTx.Plugin #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:context-level=0 #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:defer-errors #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:max-cse-iterations=0 #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:max-simplifier-iterations-pir=0 #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:max-simplifier-iterations-uplc=0 #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:datatypes=DataEncoding #-}

module Plugin.DataEncoding.Spec where

import Test.Tasty.Extras

import PlutusCore.Test
import PlutusTx.Builtins qualified as Builtins
import PlutusTx.Code
import PlutusTx.Plugin
import PlutusTx.Prelude qualified as P
import PlutusTx.Test

import Data.Proxy

-- | A very small set of data-type tests compiled with DataEncoding style.
-- These exercises constructor wrapping and case dispatch through the Data
-- representation.

dataEncoding :: TestNested
dataEncoding =
  testNested "DataEncoding" . pure . testNestedGhc $
    [ goldenPirReadable "enum" basicEnum
    , goldenPirReadable "monoConstructed" monoConstructed
    , goldenUEval "monoConstDest" [toUPlc monoCase, toUPlc monoConstructed]
    ]

-- simple enum

data MyEnum = Enum1 | Enum2

basicEnum :: CompiledCode MyEnum
basicEnum = plc (Proxy @"basicEnum") Enum1

-- monomorphic data type

data MyMonoData = Mono1 Integer Integer | Mono2 Integer | Mono3 Integer
  deriving stock (Show, Eq)

instance P.Eq MyMonoData where
  {-# INLINEABLE (==) #-}
  (Mono1 i1 j1) == (Mono1 i2 j2) = i1 P.== i2 && j1 P.== j2
  (Mono2 i1) == (Mono2 i2) = i1 P.== i2
  (Mono3 i1) == (Mono3 i2) = i1 P.== i2
  _ == _ = False

-- the expression under test

monoConstructed :: CompiledCode MyMonoData
monoConstructed = plc (Proxy @"monoConstructed") (Mono2 1)

monoCase :: CompiledCode (MyMonoData -> Integer)
monoCase =
  plc
    (Proxy @"monoCase")
    (\(x :: MyMonoData) -> case x of Mono1 _ b -> b; Mono2 a -> a; Mono3 a -> a)
