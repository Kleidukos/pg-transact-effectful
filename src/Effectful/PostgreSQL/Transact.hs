module Effectful.PostgreSQL.Transact where

import Control.DeepSeq
import Data.Int (Int64)
import Data.Kind (Type)
import Database.PostgreSQL.Simple (FromRow, Query, ToRow)
import qualified Database.PostgreSQL.Transact as DBT
import Effectful (Eff, Effect, type (:>))

import Effectful.PostgreSQL.Transact.Effect

query
  :: forall (es :: [Effect]) (parameters :: Type) (b :: Type)
   . (DB :> es, FromRow b, NFData b, ToRow parameters)
  => Query
  -> parameters
  -> Eff es [b]
query q parameters = dbtToEff $ DBT.query q parameters

query_
  :: forall (es :: [Effect]) (b :: Type)
   . (DB :> es, FromRow b, NFData b)
  => Query
  -> Eff es [b]
query_ q = dbtToEff $ DBT.query_ q

queryOne
  :: forall (es :: [Effect]) (parameters :: Type) (b :: Type)
   . (DB :> es, FromRow b, NFData b, ToRow parameters)
  => Query
  -> parameters
  -> Eff es (Maybe b)
queryOne q parameters = dbtToEff $ DBT.queryOne q parameters

queryOne_
  :: forall (es :: [Effect]) (b :: Type)
   . (DB :> es, FromRow b, NFData b)
  => Query
  -> Eff es (Maybe b)
queryOne_ q = dbtToEff $ DBT.queryOne_ q

execute
  :: forall (es :: [Effect]) (parameters :: Type)
   . (DB :> es, ToRow parameters)
  => Query
  -> parameters
  -> Eff es Int64
execute q parameters = dbtToEff $ DBT.execute q parameters

execute_
  :: forall (es :: [Effect])
   . DB :> es
  => Query
  -> Eff es Int64
execute_ q = dbtToEff $ DBT.execute_ q

executeMany
  :: forall (es :: [Effect]) (parameters :: Type)
   . (DB :> es, ToRow parameters)
  => Query
  -> [parameters]
  -> Eff es Int64
executeMany q parameters = dbtToEff $ DBT.executeMany q parameters
