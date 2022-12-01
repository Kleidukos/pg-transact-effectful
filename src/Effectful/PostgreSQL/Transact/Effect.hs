module Effectful.PostgreSQL.Transact.Effect
  ( DB
  , runDB
  , dbtToEff
  , getPool
  )
where

import Control.DeepSeq (NFData, force)
import Control.Exception
import Control.Monad.Reader (runReaderT)
import Data.Kind (Type)
import Data.Pool (Pool)
import qualified Data.Pool as Pool
import Database.PostgreSQL.Simple (Connection)
import Database.PostgreSQL.Transact (DBT (..))
import Effectful
import Effectful.Dispatch.Static

data DB :: Effect

type instance DispatchOf DB = Static WithSideEffects
newtype instance StaticRep DB = DB (Pool Connection)

runDB
  :: forall (es :: [Effect]) (a :: Type)
   . (IOE :> es)
  => Pool Connection
  -> Eff (DB : es) a
  -> Eff es a
runDB pool m = do
  evalStaticRep (DB pool) m

getPool :: (DB :> es) => Eff es (Pool Connection)
getPool = do
  DB pool <- getStaticRep
  pure pool

-- effToDBT :: forall (a :: Type). ()
--          => Eff '[DB, IOE] a
--          -> DBT IO a
-- effToDBT computation = do
--   pool <- DBT.getConnection
--   liftIO . runEff . runDB pool $ computation

dbtToEff
  :: (DB :> es, NFData a)
  => DBT IO a
  -> Eff es a
dbtToEff (DBT dbtComputation) = do
  DB pool <- getStaticRep
  result <- unsafeEff_ $! Pool.withResource pool $ \conn ->
    runReaderT dbtComputation conn
  unsafeEff_ (evaluate . force $! result)
