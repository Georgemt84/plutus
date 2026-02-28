module Cardano.Constitution.Validator.Data.GoldenTests
  ( tests
  ) where

import Cardano.Constitution.Config
import Cardano.Constitution.Data.Validator
import Cardano.Constitution.Validator.TestsCommon
import Cardano.Constitution.Validator.GoldenTestsCommon (mkGoldenTests)
import UntypedPlutusCore qualified as UPLC
import UntypedPlutusCore.Evaluation.Machine.Cek qualified as CEK
import PlutusTx.IsData.Class (unsafeFromBuiltinData, toBuiltinData)

tests :: TestTreeWithTestState
tests = mkGoldenTests ["test", "Cardano", "Constitution", "Validator", "Data", "GoldenTests"] defaultValidatorsWithCodes runForBudget

-- runForBudget for the data-backed validators: we apply unsafeFromBuiltinData . toBuiltinData
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
              `unsafeApplyCode` liftCode110 (unsafeFromBuiltinData . toBuiltinData $ ctx)
     in case CEK.runCekDeBruijn defaultCekParametersForTesting counting noEmitter vPs of
       CEK.CekReport (CEK.CekSuccessConstant (CEK.Some (CEK.ValueOf CEK.DefaultUniUnit ()))) (CEK.CountingSt budget) _ -> budget
       _ -> error "For safety, we only compare budgets of successful executions."
        -- resulting in misleading low budget costs.
        UPLC.CekReport (UPLC.CekSuccessConstant (UPLC.Some (UPLC.ValueOf UPLC.DefaultUniUnit ()))) (UPLC.CountingSt budget) _ -> budget
        _ -> error "For safety, we only compare budgets of successful executions."
