(program
   1.1.0
   (\xs ->
      case
        (force dropList 5 xs)
        [ (\x xs ds _ann -> x)
        , (\_ann -> (\x -> error) (force trace "PlutusTx.BuiltinList.!!: index too large" (constr 0 []))) ]
        (constr 0 [])
        (constr 0 [])))