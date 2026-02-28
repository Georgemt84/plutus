let
  data Unit | Unit_match where
    Unit : Unit
in
letrec
  !last : all a. list a -> a
    = /\a ->
        \(eta : list a) ->
          case
            (Unit -> a)
            eta
            [ (\(x : a) (xs : list a) (ds : Unit) ->
                 case a xs [(\(ds : a) (ds : list a) -> last {a} xs), x])
            , (\(ds : Unit) ->
                 let
                   !x : Unit = trace {Unit} "PlutusTx.BuiltinList.last: empty list" Unit
                 in
                 error {a}) ]
            Unit
in
\(ds : list integer) -> last {integer} []