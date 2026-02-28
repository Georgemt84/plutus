-- editorconfig-checker-disable-file
{-# LANGUAGE GADTs #-}

module Cardano.Constitution.Validator.GoldenTestsCommon
  ( mkGoldenTests
  ) where

import PlutusCore.Default as UPLC
import PlutusCore.Evaluation.Machine.ExBudget
import PlutusCore.Evaluation.Machine.ExBudgetingDefaults
import PlutusCore.Pretty (prettyPlcReadableSimple)
import PlutusLedgerApi.V3 as V3
import PlutusLedgerApi.V3.ArbitraryContexts as V3
import PlutusTx.Code as Tx
import UntypedPlutusCore as UPLC
import UntypedPlutusCore.Evaluation.Machine.Cek as UPLC

import Data.ByteString.Short qualified as SBS
import Data.Map.Strict qualified as M
import Data.Maybe
import Data.String
import System.FilePath
import Test.Tasty
import Test.Tasty.Golden

import Cardano.Constitution.Config
import Cardano.Constitution.Validator (ConstitutionValidator)
import Helpers.TestBuilders

-- | Build the golden tests for a set of validators.
-- basePathSegments should be the path segments up to the GoldenTests directory
-- e.g. ["test","Cardano","Constitution","Validator","GoldenTests"]
mkGoldenTests
  :: ToData ctx
  => [FilePath]
  -> M.Map String (ConstitutionValidator, CompiledCode ConstitutionValidator)
  -> (CompiledCode ConstitutionValidator -> ctx -> ExBudget)
  -> TestTreeWithTestState
mkGoldenTests basePathSegments vmap runForBudget' =
  testGroup' "Golden" $ fmap const
    [ testGroup "Cbor" $
        M.elems $
          ( \vName (_, vCode) ->
              goldenVsString vName (mkPath vName ["cbor", "size"]) $
                pure $ fromString $ show $ SBS.length $ V3.serialiseCompiledCode vCode
          )
            `M.mapWithKey` vmap
    , testGroup "BudgetLarge" $
        M.elems $
          ( \vName (_, vCode) ->
              goldenVsString vName (mkPath vName ["large", "budget"]) $
                pure $ fromString $ show $ runForBudget' vCode $ V3.mkFakeParameterChangeContext getFakeLargeParamsChange
          )
            `M.mapWithKey` vmap
    , testGroup "BudgetSmall" $
        M.elems $
          ( \vName (_, vCode) ->
              goldenVsString vName (mkPath vName ["small", "budget"]) $
                pure $ fromString $ show $ runForBudget' vCode $ V3.mkSmallFakeProposal defaultConstitutionConfig
          )
            `M.mapWithKey` vmap
    , testGroup "ReadablePir" $
        M.elems $
          ( \vName (_, vCode) ->
              goldenVsString vName (mkPath vName ["pir"]) $
                pure $ fromString $ show $ prettyPlcReadableSimple $ fromJust $ getPirNoAnn vCode
          )
            `M.mapWithKey` vmap
    , testGroup "ReadableUplc" $
        M.elems $
          ( \vName (_, vCode) ->
              goldenVsString vName (mkPath vName ["uplc"]) $
                pure $ fromString $ show $ prettyPlcReadableSimple $ getPlcNoAnn vCode
          )
            `M.mapWithKey` vmap
    ]
  where
    mkPath vName exts = foldl1 (</>) (basePathSegments ++ [foldl (<.>) vName ("golden" : exts)])
