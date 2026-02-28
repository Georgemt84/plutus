let
  data Unit | Unit_match where
    Unit : Unit
in
\(ds : list integer) ->
  (let
      r = Unit -> integer
    in
    \(z : r) (f : integer -> list integer -> r) (xs : list integer) ->
      case r xs [f, z])
    (\(ds : Unit) ->
       let
         !x : Unit = trace {Unit} "PlutusTx.BuiltinList.head: empty list" Unit
       in
       error {integer})
    (\(x : integer) (xs : list integer) (ds : Unit) -> x)
    []
    Unit