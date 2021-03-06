module Tests.DeBruijnUT where

import DeBruijnUT
       
cpstests :: [(E,E,String)]
cpstests = [ (t1, t1cps, "t1")
           , (t2, t2cps, "t2")
           , (fact, factcps, "fact")
           , (t3, t3cps, "t3")
           , (t4, t4cps, "t4")
           , (fib, fibcps, "fib")
           , (t5, t5cps, "t5") ]

cpsdriver :: E -> E
cpsdriver e = cps e 0 0 const

testcps :: (E,E,String) -> IO ()
testcps (t,t',name) = do
  let result = cpsdriver t
  if result == t' then putStrLn $ name ++ " OK"
  else (do putStrLn $ "Test failure: " ++ name
           putStrLn "cps of "
           print $ show t
           putStrLn "should be"
           print $ show t'
           putStrLn "is actually"
           print $ show result)

runcpstests :: IO ()
runcpstests = mapM_ testcps cpstests >> putStrLn "" >> putStrLn "Done."

runeval :: IO ()
runeval = do
  let     -- \x -> (\b -> if b then (3+x) else (3*x))
      e = Lam (Lam (If (V 0) (Plus (N 3) (V 1)) (Times (N 3) (V 1))))
      a = App (App e (N 2)) (B True)
  print e
  print a
  let UN ans = eval [] a -- ^ ans = 5
      UN onetwenty = eval [] (App fact (N ans))
  print ans
  print onetwenty

-- cps (\x y -> x y)
-- => (\x k -> k (\y k' -> x y (\v -> k' v)))
-- => (\x k -> k (\y k' -> x y k'))
t1 = (Lam (Lam (App (V 1) (V 0))))
t1cps = (Lam
         (Lam
          (App
           (V 0)
           (Lam
            (Lam
             (App
              (App (V 3) (V 1))
              (Lam (App (V 1) (V 0)))))))))

t2 = (Plus (If (B True) (N 2) (N 3)) (N 5))
t2cps = (If (B True)
         (Plus (N 2) (N 5))
         (Plus (N 3) (N 5)))

fix f = f (fix f)        

factorial = fix $ \rf n -> if n <= 0 then 1 else n * (rf (n-1))
factorialcps = fix $ \rf n k -> if n <= 0 then (k 1) else rf (n-1) (\x -> k $ n * x)               
        
fact = Fix (Lam
            (Lam
             (If (Leq (V 0) (N 1))
                 (N 1)
                 (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))))))
factcps = Fix 
          (Lam 
           (Lam 
            (App (V 0) 
             (Lam 
              (Lam 
               (If (Leq (V 1) (N 1)) 
                (App (V 0) (N 1)) 
                (App 
                 (App (V 3) (Plus (V 1) (N (-1)))) 
                 (Lam (App (V 1) (Times (V 2) (V 0)))))))))))

t3 = (Plus (App (V 3) (N 10)) (N 50))
t3cps = (App
         (App (V 3) (N 10))
         (Lam (Plus (V 0) (N 50))))

t4 = (Plus (App (V 3) (N 10)) (V 50))
t4cps = (App
         (App (V 3) (N 10))
         (Lam (Plus (V 0) (V 51))))

fibonacci = \n -> if n <= 1 then 1
                  else (if n <= 2 then 1
                        else fibonacci (n-1) + fibonacci (n-2))
fibonaccicps = \n k -> if n <= 1 then (k 1)
                       else (if n <= 2 then (k 1)
                             else fibonaccicps (n-1)
                                      (\x1 -> fibonaccicps (n-2)
                                              (\x2 -> k (x1 + x2))))

fib = Fix
      (Lam  -- r
       (Lam -- n
        (If (Leq (V 0) (N 1))
            (N 1)
            (If (Leq (V 0) (N 2))
                (N 1)
                (Plus (App (V 1) (Plus (V 0) (N (-1))))
                      (App (V 1) (Plus (V 0) (N (-2)))))))))

fibcps = Fix
         (Lam
          (Lam
           (App (V 0)
            (Lam
             (Lam
              (If (Leq (V 1) (N 1))
               (App (V 0) (N 1))
               (If (Leq (V 1) (N 2))
                (App (V 0) (N 1))
                (App
                 (App (V 3) (Plus (V 1) (N (-1))))
                 (Lam
                  (App
                   (App (V 4) (Plus (V 2) (N (-2))))
                   (Lam (App (V 2) (Plus (V 1) (V 0))))))))))))))

-- cps ((\x -> x) 10)
-- => (\x k -> k x) 10 (\x -> x)
t5 = (App (Lam (V 0)) (N 10))
t5cps = (App
         (App
          (Lam (Lam (App (V 0) (V 1))))
          (N 10))
         (Lam (V 0)))

