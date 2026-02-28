(program
   1.1.0
   (\xs ->
      case
        xs
        [ (\x xs ds -> x)
        , (\ds -> (\x -> error) (force trace "PlutusTx.BuiltinList.head: empty list" (constr 0 []))) ]
        (constr 0 [])))