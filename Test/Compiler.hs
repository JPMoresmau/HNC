module Test.Compiler (iotests) where
import Test.HUnit hiding (test)
import System.Directory
import Control.Monad

import CPP.CompileTools

comp2 f g x y = f $ g x y

test testName =	liftM2 (comp2 (testName ~:) (~=?))
	(readFile $ "hn_tests/" ++ testName ++ ".cpp")
	(compile2 id $ "hn_tests/" ++ testName ++ ".hn")


iotests =
	getDirectoryContents "hn_tests" >>=
	return . map fst . filter (\x -> snd x == ".hn") . map (break (== '.')) >>=
	mapM test



