let
  data Unit | Unit_match where
    Unit : Unit
in
\(xs : list integer) ->
  let
    !x : Unit = trace {Unit} "PlutusTx.BuiltinList.!!: negative index" Unit
  in
  error {integer}