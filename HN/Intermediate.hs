module HN.Intermediate where
import qualified Data.Set as S
import SPL.Types (T)


type Program = [Definition]

data Const      =   ConstString String
                |   ConstInt    Int
 --               |   ConstReal   Double
 --               |   ConstChar   Char
 --               |   ConstBool   Bool
                    deriving Eq

data LetIn = Let Definition LetIn | In ASTExpression
	deriving (Eq,Show)

letValue (Let _ l) = letValue l
letValue (In v) = v

letWhere (Let d l) = d : letWhere l
letWhere (In _) = []

makeLet :: ASTExpression -> Program -> LetIn
makeLet v = foldr Let (In v)

insertLet prg (Definition name args (In value)) = Definition name args $ makeLet value prg

data Definition
	=   Definition String [String] LetIn
	|	Assign String LetIn
--	|	While Expression LetIn
--	|	If Expression LetIn LetIn
    deriving(Eq,Show)

type ASTExpression = Expression String
type ExpressionList  = [ASTExpression]
type GType = (S.Set String, T)

type Root = Program

data Expression a
    =   Application (Expression a) [Expression a]
    |   Atom a
    |   Constant Const
    |   Lambda [a] (Expression a)
    deriving Eq

instance Functor Expression where
	fmap f y = case y of
		Atom a -> Atom $ f a
		Application x y -> Application (fmap f x) $ map (fmap f) y
		Constant x -> Constant x

instance Show Const where
	show (ConstString x) = show x
	show (ConstInt x) = show x

instance Show a => Show (Expression a) where
	show e = case e of
		Constant c -> show c
		Atom aa -> show aa
		Application a b -> show a ++ concatMap (\b -> ' ' : show b) b
