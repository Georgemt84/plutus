(program
   1.1.0
   (\xs ->
      case
        xs
        [ (\x xs ds -> xs)
        , (\ds -> (\x -> error) (force trace "PlutusTx.BuiltinList.last: empty list" (constr 0 []))) ]
        (constr 0 [])))