-- editorconfig-checker-disable-file
{-# LANGUAGE GADTs #-}

module Cardano.Constitution.Validator.GoldenTests
  ( tests
  ) where

import Cardano.Constitution.Data.Validator ()
import Cardano.Constitution.Config
import Cardano.Constitution.Validator
import Cardano.Constitution.Validator.TestsCommon
import Cardano.Constitution.Validator.GoldenTestsCommon (mkGoldenTests)

import Data.Map.Strict qualified as M
import UntypedPlutusCore qualified as UPLC
import UntypedPlutusCore.Evaluation.Machine.Cek qualified as CEK
import PlutusTx.IsData.Class (toBuiltinData)

tests :: TestTreeWithTestState
tests = mkGoldenTests ["test", "Cardano", "Constitution", "Validator", "GoldenTests"] defaultValidatorsWithCodes runForBudget

-- runForBudget for the regular (non-data) validators
runForBudget
  :: ToData ctx
  => CompiledCode ConstitutionValidator
  -> ctx
  -> ExBudget
runForBudget v ctx =
  let vPs =
        UPLC._progTerm $
          getPlcNoAnn $
            v
              `unsafeApplyCode` liftCode110 (toBuiltinData ctx)
     in case CEK.runCekDeBruijn defaultCekParametersForTesting counting noEmitter vPs of
       CEK.CekReport (CEK.CekSuccessConstant (CEK.Some (CEK.ValueOf CEK.DefaultUniUnit ()))) (CEK.CountingSt budget) _ -> budget
        _ -> error "For safety, we only compare budget of succesful executions."
