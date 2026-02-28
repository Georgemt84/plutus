{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-omit-interface-pragmas #-}

module PlutusTx.ErrorCodes where

import Data.Map (Map)
import Data.Map qualified as Map
import PlutusTx.Builtins as Builtins
import Prelude (String)

{-
All error messages in this module should be unique and can be used only once!
They help to trace the errors in on-chain code.

Previously Plutus used short codes (e.g. "PT1") in order keep contracts small, with the
human-readable description stored separately.  In order to make contract failures easier
to diagnose we now encode the full message directly in the script, at the cost of
a slightly larger compiled size.  The message should therefore be clear and informative.

Adding a new error message should be done in step with the map below:
- Add a new entry to `plutusPreludeErrorCodes` associating the message with itself or a
  detailed description for offline tooling.
- Add a new function with the error name returning the same string.
- Update the `troubleshooting.rst` file (or its modern equivalent) with the new message.

When writing a new error message please follow existing patterns:
  - If an error is expected to be thrown in a specific function,
    use the fully qualified name of the function.
  - Describe the invariant which is failed.
  - Avoid using the word "error" in the description as it is redundant.
-}

{- Note [plutusPreludeErrorCodes]
   This list contains all error codes used in the plutus prelude and it is
   important that when an error code is added to the prelude it is also added
   to this list.
-}

-- | All error codes used in the plutus prelude associated with a human-readable description.
plutusPreludeErrorCodes :: Map Builtins.BuiltinString String
plutusPreludeErrorCodes =
  Map.fromList
    [ ("TH Generation of Indexed Data Error", "TH Generation of Indexed Data Error")
    , ("PlutusTx.IsData.Class.unsafeFromBuiltinData: Void is not supported", "PlutusTx.IsData.Class.unsafeFromBuiltinData: Void is not supported")
    , ("PlutusTx.Ratio: zero denominator", "PlutusTx.Ratio: zero denominator")
    , ("PlutusTx.Prelude.check: input is 'False'", "PlutusTx.Prelude.check: input is 'False'")
    , ("PlutusTx.List.!!: negative index", "PlutusTx.List.!!: negative index")
    , ("PlutusTx.List.!!: index too large", "PlutusTx.List.!!: index too large")
    , ("PlutusTx.List.head: empty list", "PlutusTx.List.head: empty list")
    , ("PlutusTx.List.tail: empty list", "PlutusTx.List.tail: empty list")
    , ("PlutusTx.List.last: empty list", "PlutusTx.List.last: empty list")
    , ("PlutusTx.Ratio.recip: reciprocal of zero", "PlutusTx.Ratio.recip: reciprocal of zero")
    , ("PlutusTx.BuiltinList.!!: negative index", "PlutusTx.BuiltinList.!!: negative index")
    , ("PlutusTx.BuiltinList.!!: index too large", "PlutusTx.BuiltinList.!!: index too large")
    , ("PlutusTx.BuiltinList.head: empty list", "PlutusTx.BuiltinList.head: empty list")
    , ("PlutusTx.BuiltinList.tail: empty list", "PlutusTx.BuiltinList.tail: empty list")
    , ("PlutusTx.BuiltinList.last: empty list", "PlutusTx.BuiltinList.last: empty list")
    , ("PlutusTx.Enum.succ: bad argument", "PlutusTx.Enum.succ: bad argument")
    , ("PlutusTx.Enum.pred: bad argument", "PlutusTx.Enum.pred: bad argument")
    , ("PlutusTx.Enum.toEnum: bad argument", "PlutusTx.Enum.toEnum: bad argument")
    , -- the following are retired
      ("PlutusTx.Enum.().succ: bad argument", "PlutusTx.Enum.().succ: bad argument")
    , ("PlutusTx.Enum.().pred: bad argument", "PlutusTx.Enum.().pred: bad argument")
    , ("PlutusTx.Enum.().toEnum: bad argument", "PlutusTx.Enum.().toEnum: bad argument")
    , ("PlutusTx.Enum.Bool.succ: bad argument", "PlutusTx.Enum.Bool.succ: bad argument")
    , ("PlutusTx.Enum.Bool.pred: bad argument", "PlutusTx.Enum.Bool.pred: bad argument")
    , ("PlutusTx.Enum.Bool.toEnum: bad argument", "PlutusTx.Enum.Bool.toEnum: bad argument")
    , ("PlutusTx.Enum.Ordering.succ: bad argument", "PlutusTx.Enum.Ordering.succ: bad argument")
    , ("PlutusTx.Enum.Ordering.pred: bad argument", "PlutusTx.Enum.Ordering.pred: bad argument")
    , ("PlutusTx.Enum.Ordering.toEnum: bad argument", "PlutusTx.Enum.Ordering.toEnum: bad argument")
    ]

-- | The error happens in TH generation of indexed data
reconstructCaseError :: Builtins.BuiltinString
reconstructCaseError = "TH Generation of Indexed Data Error"
{-# INLINEABLE reconstructCaseError #-}

-- | Error case of 'unsafeFromBuiltinData'
voidIsNotSupportedError :: Builtins.BuiltinString
voidIsNotSupportedError = "PlutusTx.IsData.Class.unsafeFromBuiltinData: Void is not supported"
{-# INLINEABLE voidIsNotSupportedError #-}

-- | Ratio number can't have a zero denominator
ratioHasZeroDenominatorError :: Builtins.BuiltinString
ratioHasZeroDenominatorError = "PlutusTx.Ratio: zero denominator"
{-# INLINEABLE ratioHasZeroDenominatorError #-}

-- | 'check' input is 'False'
checkHasFailedError :: Builtins.BuiltinString
checkHasFailedError = "PlutusTx.Prelude.check: input is 'False'"
{-# INLINEABLE checkHasFailedError #-}

-- | PlutusTx.List.!!: negative index
negativeIndexError :: Builtins.BuiltinString
negativeIndexError = "PlutusTx.List.!!: negative index"
{-# INLINEABLE negativeIndexError #-}

-- | PlutusTx.List.!!: index too large
indexTooLargeError :: Builtins.BuiltinString
indexTooLargeError = "PlutusTx.List.!!: index too large"
{-# INLINEABLE indexTooLargeError #-}

-- | PlutusTx.List.head: empty list
headEmptyListError :: Builtins.BuiltinString
headEmptyListError = "PlutusTx.List.head: empty list"
{-# INLINEABLE headEmptyListError #-}

-- | PlutusTx.List.tail: empty list
tailEmptyListError :: Builtins.BuiltinString
tailEmptyListError = "PlutusTx.List.tail: empty list"
{-# INLINEABLE tailEmptyListError #-}

-- | PlutusTx.Enum.().succ: bad argument
succBadArgumentError :: Builtins.BuiltinString
succBadArgumentError = "PlutusTx.Enum.succ: bad argument"
{-# INLINEABLE succBadArgumentError #-}

-- | PlutusTx.Enum.().pred: bad argument
predBadArgumentError :: Builtins.BuiltinString
predBadArgumentError = "PlutusTx.Enum.pred: bad argument"
{-# INLINEABLE predBadArgumentError #-}

-- | PlutusTx.Enum.().toEnum: bad argument
toEnumBadArgumentError :: Builtins.BuiltinString
toEnumBadArgumentError = "PlutusTx.Enum.toEnum: bad argument"
{-# INLINEABLE toEnumBadArgumentError #-}

{-# DEPRECATED succVoidBadArgumentError, predVoidBadArgumentError, toEnumVoidBadArgumentError, succBoolBadArgumentError, predBoolBadArgumentError, toEnumBoolBadArgumentError, succOrderingBadArgumentError, predOrderingBadArgumentError, toEnumOrderingBadArgumentError "Use [succ|pred|toEnum]BadArgumentError instead." #-}

-- | PlutusTx.Enum.().succ: bad argument
succVoidBadArgumentError :: Builtins.BuiltinString
succVoidBadArgumentError = "PlutusTx.Enum.().succ: bad argument"
{-# INLINEABLE succVoidBadArgumentError #-}

-- | PlutusTx.Enum.().pred: bad argument
predVoidBadArgumentError :: Builtins.BuiltinString
predVoidBadArgumentError = "PlutusTx.Enum.().pred: bad argument"
{-# INLINEABLE predVoidBadArgumentError #-}

-- | PlutusTx.Enum.().toEnum: bad argument
toEnumVoidBadArgumentError :: Builtins.BuiltinString
toEnumVoidBadArgumentError = "PlutusTx.Enum.().toEnum: bad argument"
{-# INLINEABLE toEnumVoidBadArgumentError #-}

-- | PlutusTx.Enum.Bool.succ: bad argument
succBoolBadArgumentError :: Builtins.BuiltinString
succBoolBadArgumentError = "PlutusTx.Enum.Bool.succ: bad argument"
{-# INLINEABLE succBoolBadArgumentError #-}

-- | PlutusTx.Enum.Bool.pred: bad argument
predBoolBadArgumentError :: Builtins.BuiltinString
predBoolBadArgumentError = "PlutusTx.Enum.Bool.pred: bad argument"
{-# INLINEABLE predBoolBadArgumentError #-}

-- | PlutusTx.Enum.Bool.toEnum: bad argument
toEnumBoolBadArgumentError :: Builtins.BuiltinString
toEnumBoolBadArgumentError = "PlutusTx.Enum.Bool.toEnum: bad argument"
{-# INLINEABLE toEnumBoolBadArgumentError #-}

-- | PlutusTx.Enum.Ordering.succ: bad argument
succOrderingBadArgumentError :: Builtins.BuiltinString
succOrderingBadArgumentError = "PlutusTx.Enum.Ordering.succ: bad argument"
{-# INLINEABLE succOrderingBadArgumentError #-}

-- | PlutusTx.Enum.Ordering.pred: bad argument
predOrderingBadArgumentError :: Builtins.BuiltinString
predOrderingBadArgumentError = "PlutusTx.Enum.Ordering.pred: bad argument"
{-# INLINEABLE predOrderingBadArgumentError #-}

-- | PlutusTx.Enum.Ordering.toEnum: bad argument
toEnumOrderingBadArgumentError :: Builtins.BuiltinString
toEnumOrderingBadArgumentError = "PlutusTx.Enum.Ordering.toEnum: bad argument"
{-# INLINEABLE toEnumOrderingBadArgumentError #-}

-- | PlutusTx.List.last: empty list
lastEmptyListError :: Builtins.BuiltinString
lastEmptyListError = "PlutusTx.List.last: empty list"
{-# INLINEABLE lastEmptyListError #-}

-- | PlutusTx.Ratio.recip: reciprocal of zero
reciprocalOfZeroError :: Builtins.BuiltinString
reciprocalOfZeroError = "PlutusTx.Ratio.recip: reciprocal of zero"
{-# INLINEABLE reciprocalOfZeroError #-}

-- | PlutusTx.BuiltinList.!!: negative index
builtinListNegativeIndexError :: Builtins.BuiltinString
builtinListNegativeIndexError = "PlutusTx.BuiltinList.!!: negative index"
{-# INLINEABLE builtinListNegativeIndexError #-}

-- | PlutusTx.BuiltinList.!!: index too large
builtinListIndexTooLargeError :: Builtins.BuiltinString
builtinListIndexTooLargeError = "PlutusTx.BuiltinList.!!: index too large"
{-# INLINEABLE builtinListIndexTooLargeError #-}

-- | PlutusTx.BuiltinList.head: empty list
headEmptyBuiltinListError :: Builtins.BuiltinString
headEmptyBuiltinListError = "PlutusTx.BuiltinList.head: empty list"
{-# INLINEABLE headEmptyBuiltinListError #-}

-- | PlutusTx.BuiltinList.tail: empty list
tailEmptyBuiltinListError :: Builtins.BuiltinString
tailEmptyBuiltinListError = "PlutusTx.BuiltinList.tail: empty list"
{-# INLINEABLE tailEmptyBuiltinListError #-}

-- | PlutusTx.BuiltinList.last: empty list
lastEmptyBuiltinListError :: Builtins.BuiltinString
lastEmptyBuiltinListError = "PlutusTx.BuiltinList.last: empty list"
{-# INLINEABLE lastEmptyBuiltinListError #-}
