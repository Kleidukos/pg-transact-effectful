module Effectful.PostgreSQL.Transact where

import qualified Database.PostgreSQL.Transact as DBT
import Effectful.PostgreSQL.Transact.Effect
import Database.PostgreSQL.Simple (Query, ToRow, FromRow)
import Effectful (Effect, type (:>), Eff, IOE)
import Data.Kind (Type)
import Data.Int (Int64)

query :: forall (es :: [Effect]) (parameters :: Type) (b :: Type).
         (IOE :> es, DB :> es, ToRow parameters, FromRow b)
      => Query
      -> parameters 
      -> Eff es [b]
query q parameters = dbtToEff $ DBT.query q parameters

query_ :: forall (es :: [Effect]) (b :: Type). (IOE :> es, DB :> es, FromRow b)
      => Query
      -> Eff es [b]
query_ q = dbtToEff $ DBT.query_ q 

queryOne :: forall (es :: [Effect]) (parameters :: Type) (b :: Type).
         (IOE :> es, DB :> es, ToRow parameters, FromRow b)
      => Query
      -> parameters 
      -> Eff es (Maybe b)
queryOne q parameters = dbtToEff $ DBT.queryOne q parameters

queryOne_ :: forall (es :: [Effect]) (b :: Type).
         (IOE :> es, DB :> es, FromRow b)
      => Query
      -> Eff es (Maybe b)
queryOne_ q = dbtToEff $ DBT.queryOne_ q 


execute :: forall (es :: [Effect]) (parameters :: Type). (ToRow parameters, IOE :> es, DB :> es)
        => Query
        -> parameters
        -> Eff es Int64
execute q parameters = dbtToEff $ DBT.execute q parameters

execute_ :: forall (es :: [Effect]). (IOE :> es, DB :> es)
        => Query
        -> Eff es Int64
execute_ q = dbtToEff $ DBT.execute_ q 

executeMany :: forall (es :: [Effect]) (parameters :: Type). (ToRow parameters, IOE :> es, DB :> es)
            => Query
            -> [parameters]
            -> Eff es Int64
executeMany q parameters = dbtToEff $ DBT.executeMany q parameters
