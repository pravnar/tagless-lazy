{-|

--------------------------------------------------------------------------------
t1 = (Lam   -- ^ f
      (Lam  -- ^ n
       (App (V 1) (V 0))))

cps t1 0 id should be:

Lam     -- f
(Lam    -- k
 (App
  (V 0)
  (Lam  -- n
   (Lam -- k
    (App
     (App (V 3) (V 1))
     (Lam (App (V 1) (V 0))))))))

cps t1 0 id currently is:

Lam 
(Lam 
 (App 
  (V 0) 
  (Lam 
   (Lam 
    (App 
     (App (V 3) (V 1)) 
     (Lam (App (V 1) (V 0))))))))

Lam 
(Lam 
 (App 
  (V 0) 
  (Lam 
   (Lam 
    (App 
     (App (V 3) (V 1)) 
     (Lam (App (V 1) (V 0))))))))

Let's step through the execution:

cps (Lam (Lam (App (V 1) (V 0)))) 0 id

id (Lam (Lam (cps (Lam (App (V 1) (V 0))) 1 (\v -> (App (V 0) v)))))

(Lam (Lam (cps (Lam (App (V 1) (V 0))) 1 (\v -> (App (V 0) v)))))

(Lam 
 (Lam 
  ((\v -> (App (V 0) v))
   (Lam
    (Lam
     (cps (App (V 1) (V 0)) 2 (\v -> (App (V 1) v))))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     (cps (App (V 1) (V 0)) 2 (\v -> (App (V 1) v))))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     (cps (V 1) 2
      (\v1 -> cps (V 0) 2
              (\v2 -> (App 
                       (App v1 v2) 
                       (Lam 
                        ((\v -> (App (V 1) v))
                         (V 0))))))))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     (cps (V 1) 2
      (\v1 -> cps (V 0) 2
              (\v2 -> (App 
                       (App v1 v2) 
                       (Lam 
                        (App (V 1) (V 0))))))))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     ((\v1 -> cps (V 0) 2
              (\v2 -> (App 
                       (App v1 v2) 
                       (Lam 
                        (App (V 1) (V 0))))))
      (V 3)))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     (cps (V 0) 2
      (\v2 -> (App 
               (App (V 3) v2) 
               (Lam 
                (App (V 1) (V 0)))))))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     ((\v2 -> (App 
               (App (V 3) v2) 
               (Lam 
                (App (V 1) (V 0)))))
      (V 2)))))))

(Lam 
 (Lam 
  (App
   (V 0)
   (Lam
    (Lam
     (App 
      (App (V 3) (V 2)) 
      (Lam (App (V 1) (V 0)))))))))


--------------------------------------------------------------------------------


      
--------------------------------------------------------------------------------
cps (App (Lam (V 0)) (B True)) with k = id
(App (App (Lam (Lam (App (V 1) (V 0)))) (Lam (k (V 0)))) (B True))
(App (Lam (App (Lam (k (V 0))) (V 0))) (B True))
(App (Lam (k (V 0))) (B True))
(k (B True))
(B True)
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
For fact, we should get:

Fix
(Lam -- rec
 (Lam -- k1
  (App (V 0)
   (Lam -- n
    (Lam -- k2
     (If (Leq (V 1) (N 1))
      (App (V 0) (N 1))
      (App
       (App (V 3) (Plus (V 1) (N (-1))))
       (Lam (App (V 1) (Times (V 2) (V 0)))))))))))

What we currently get:

Fix 
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

Fix 
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


Fix 
(Lam 
 (Lam 
  (App (V 0) 
   (Lam 
    (Lam 
     (If (Leq (V 1) (N 1)) 
      (App (V 1) (N 1)) 
      (App 
       (App (V 3) (Plus (V 1) (N (-1)))) 
       (Lam (App (V 1) (Times (V 1) (V 0)))))))))))

Fix 
(Lam 
 (Lam 
  (App (V 0) 
   (Lam 
    (Lam 
     (If (Leq (V 1) (N 1)) 
      (App (V 1) (N 1)) 
      (App 
       (App (V 3) (Plus (V 1) (N (-1)))) 
       (Lam (App (V 1) (Times (V 1) (V 0)))))))))))

What we used to get:

Fix
(Lam
 (Lam
  (App (V 500)
   (Lam
    (Lam
     (If (Leq (V 2) (N 1))
      (App (V 500) (N 1))
      (App
       (App (V 3) (Plus (V 2) (N (-1))))
       (Lam (App (V 500) (Times (V 2) (V 0)))))))))))

(Fix
 (Lam
  (Lam
   (App (V 1)
    (Lam
     (Lam
      (If (Leq (V 0) (N 1))
       (App (V 1) (N 1))
       (App
        (App (V 1) (Lam (App (V 1) (Times (V 0) (V 0)))))
        (Plus (V 0) (N (-1)))))))))))


Let's step through what currently happens
      
cps almost-fact 0 0 const

cps 
(Lam
 (Lam
  (If (Leq (V 0) (N 1))
      (N 1)
      (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))))))
0 0 const

const
(Lam
 (Lam
  (cps (Lam
        (If (Leq (V 0) (N 1))
            (N 1)
            (Times (V 0) (App (V 1) (Plus (V 0) (N (-1)))))))
       1 0 (\v m' -> (App (V m') v))))) 0

(Lam
 (Lam
  (cps (Lam
        (If (Leq (V 0) (N 1))
            (N 1)
            (Times (V 0) (App (V 1) (Plus (V 0) (N (-1)))))))
       1 0 (\v m' -> (App (V m') v)))))

(Lam 
 (Lam
  ((\v m' -> (App (V m') v))
   (Lam
    (Lam
     (cps (If (Leq (V 0) (N 1))
           (N 1)
           (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))))
      2 0 (\v m' -> (App (V m') v)))))
   0)))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (cps (If (Leq (V 0) (N 1))
           (N 1)
           (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))))
      2 0 (\v m' -> (App (V m') v))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (cps (Leq (V 0) (N 1))
          2 0 (\vc mc -> If vc 
                         (cps (N 1) 
                              2 mc (\v m' -> (App (V m') v)))
                         (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
                              2 mc (\v m' -> (App (V m') v))))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (cps (V 0) 2 0
          (\v1 m1 -> cps (N 1) 2 m1
                         (\v2 m2 -> ((\vc mc -> If vc 
                                      (cps (N 1) 
                                       2 mc (\v m' -> (App (V m') v)))
                                      (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
                                       2 mc (\v m' -> (App (V m') v))))
                                     (Leq v1 v2) m2)))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     ((\v1 m1 -> cps (N 1) 2 m1
                         (\v2 m2 -> ((\vc mc -> If vc 
                                      (cps (N 1) 
                                       2 mc (\v m' -> (App (V m') v)))
                                      (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
                                       2 mc (\v m' -> (App (V m') v))))
                                     (Leq v1 v2) m2)))
     (V 1) 0))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (cps (N 1) 2 0
          (\v2 m2 -> ((\vc mc -> If vc 
                       (cps (N 1) 
                        2 mc (\v m' -> (App (V m') v)))
                       (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
                        2 mc (\v m' -> (App (V m') v))))
                      (Leq (V 1) v2) m2))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     ((\v2 m2 -> ((\vc mc -> If vc 
                   (cps (N 1) 
                    2 mc (\v m' -> (App (V m') v)))
                   (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
                    2 mc (\v m' -> (App (V m') v))))
                  (Leq (V 1) v2) m2))
     (N 1) 0))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     ((\vc mc -> If vc 
       (cps (N 1) 
        2 mc (\v m' -> (App (V m') v)))
       (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
        2 mc (\v m' -> (App (V m') v))))
      (Leq (V 1) (N 1)) 0))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (If (Leq (V 1) (N 1))
      (cps (N 1) 
       2 0 (\v m' -> (App (V m') v)))
      (cps (Times (V 0) (App (V 1) (Plus (V 0) (N (-1))))) 
       2 0 (\v m' -> (App (V m') v)))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (If (Leq (V 1) (N 1))
      ((\v m' -> (App (V m') v))
       (N 1) 0)
      (cps (V 0) 2 0
       (\v1 m1 -> cps (App (V 1) (Plus (V 0) (N (-1)))) 2 m1
                  (\v2 m2 -> ((\v m' -> (App (V m') v))
                              (Times v1 v2) m2))))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (If (Leq (V 1) (N 1))
      (App (V 0) (N 1))
      ((\v1 m1 -> cps (App (V 1) (Plus (V 0) (N (-1)))) 2 m1
                  (\v2 m2 -> ((\v m' -> (App (V m') v))
                              (Times v1 v2) m2)))
       (V 1) 0)))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (If (Leq (V 1) (N 1))
      (App (V 0) (N 1))
      (cps (App (V 1) (Plus (V 0) (N (-1)))) 2 0
       (\v2 m2 -> ((\v m' -> (App (V m') v))
                   (Times (V 1) v2) m2)))))))))

so far so good. m has only been 0. the first argument to Times is 
already (V 1) (up from (V 0)) only because n is 2, and we called
-- cps (V 0) 2 0 (\v1 m1 -> ...) -- three traces above.

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (If (Leq (V 1) (N 1))
      (App (V 0) (N 1))
      (cps (V 1) 2 0
       (\v1 m1 -> cps (Plus (V 0) (N (-1))) 2 m1
                  (\v2 m2 -> (App
                              (App v1 v2)
                              (Lam
                               ((\v2 m2 -> ((\v m' -> (App (V m') v))
                                            (Times (V 1) v2) m2))
                                (V 0) (m2+1)))))))))))))

(Lam 
 (Lam
  (App 
   (V 0)
   (Lam
    (Lam
     (If (Leq (V 1) (N 1))
      (App (V 0) (N 1))
      (cps (V 1) 2 0
       (\v1 m1 -> cps (Plus (V 0) (N (-1))) 2 m1
                  (\v2 m2 -> (App
                              (App v1 v2)
                              (Lam
                               ((\v2 m2 -> ((\v m' -> (App (V m') v))
                                            (Times (V 1) v2) m2))
                                (V 0) (m2+1)))))))))))))


--------------------------------------------------------------------------------

-}
