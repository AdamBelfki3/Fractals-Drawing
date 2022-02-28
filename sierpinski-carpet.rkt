;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |Sierpinski Carpet Fractal|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Porject III : Sierpinski Carpet  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A visulatization of the iteration of the Sierpinski Carpet fractal


(require 2htdp/image)
(require 2htdp/universe)

(define BACKGROUND (square 1000 "solid" "white"))

;; Data Definitions:
(define-struct square-frac [top-left top-right bottom-left bottom-right center size])
;; Square-frac is a (make-square-frac Posn Posn Posn Posn Posn Number)
;; where center represents the coordinates of its center
;; top-left represents the coordinates of its top left edge
;; top-right represents the coordinates of its top right edge
;; bottom-left represents the coordinates of its bottom left edge
;; bottom-right represents the coordinates of its bottom right edge
;; and size represents the side length of the square
;; Square-frac serves to represent a square in the x-y plane,
;; using the coordinates of its four edges and center plus its side length

;; Examples:

(define SQUARE-FRAC-BACKGROUND (make-square-frac (make-posn 0 0)
                                                 (make-posn 1000 0)
                                                 (make-posn 0 1000)
                                                 (make-posn 1000 1000)
                                                 (make-posn 500 500)
                                                 1000))
(define SQUARE-FRAC-1 (make-square-frac (make-posn 0 0)
                                        (make-posn (/ 1000 3) 0)
                                        (make-posn 0 (/ 1000 3))
                                        (make-posn (/ 1000 3) (/ 1000 3))
                                        (make-posn (/ 1000 6) (/ 1000 6))
                                        (/ 1000 3)))
(define SQUARE-FRAC-2 (make-square-frac (make-posn (/ 1000 3) 0)
                                        (make-posn (* 2 (/ 1000 3)) 0)
                                        (make-posn (/ 1000 3) (/ 1000 3))
                                        (make-posn (* 2 (/ 1000 3)) (/ 1000 3))
                                        (make-posn 500 (/ 1000 6))
                                        (/ 1000 3)))
(define SQUARE-FRAC-3 (make-square-frac (make-posn (* 2 (/ 1000 3)) 0)
                                        (make-posn 1000 0)
                                        (make-posn (* 2 (/ 1000 3)) (/ 1000 3))
                                        (make-posn 1000 (/ 1000 3))
                                        (make-posn (* 5 (/ 1000 6)) (/ 1000 6))
                                        (/ 1000 3)))
(define SQUARE-FRAC-4 (make-square-frac (make-posn 0 (/ 1000 3))
                                        (make-posn (/ 1000 3) (/ 1000 3))
                                        (make-posn 0 (* 2 (/ 1000 3)))
                                        (make-posn (/ 1000 3) (* 2 (/ 1000 3)))
                                        (make-posn (/ 1000 6) 500)
                                        (/ 1000 3)))
(define SQUARE-FRAC-6 (make-square-frac (make-posn (* 2 (/ 1000 3)) (/ 1000 3))
                                        (make-posn 1000 (/ 1000 3))
                                        (make-posn (* 2 (/ 1000 3)) (* 2 (/ 1000 3)))
                                        (make-posn 1000 (* 2 (/ 1000 3)))
                                        (make-posn (* 5 (/ 1000 6)) 500)
                                        (/ 1000 3)))
(define SQUARE-FRAC-7 (make-square-frac (make-posn 0 (* 2 (/ 1000 3)))
                                        (make-posn (/ 1000 3) (* 2 (/ 1000 3)))
                                        (make-posn 0 1000)
                                        (make-posn (/ 1000 3) 1000)
                                        (make-posn (/ 1000 6) (* 5 (/ 1000 6)))
                                        (/ 1000 3)))
(define SQUARE-FRAC-8 (make-square-frac (make-posn (/ 1000 3) (* 2 (/ 1000 3)))
                                        (make-posn (* 2 (/ 1000 3)) (* 2 (/ 1000 3)))
                                        (make-posn (/ 1000 3) 1000)
                                        (make-posn (* 2 (/ 1000 3)) 1000)
                                        (make-posn 500 (* 5 (/ 1000 6)))
                                        (/ 1000 3)))
(define SQUARE-FRAC-9 (make-square-frac (make-posn (* 2 (/ 1000 3)) (* 2 (/ 1000 3)))
                                        (make-posn 1000 (* 2 (/ 1000 3)))
                                        (make-posn (* 2 (/ 1000 3)) 1000)
                                        (make-posn 1000 1000)
                                        (make-posn (* 5 (/ 1000 6)) (* 5 (/ 1000 6)))
                                        (/ 1000 3)))
(define SQUARE-FRAC-MID (make-square-frac (make-posn (/ 1000 3) (/ 1000 3))
                                          (make-posn (* 2 (/ 1000 3)) (/ 1000 3))
                                          (make-posn (/ 1000 3) (* 2 (/ 1000 3)))
                                          (make-posn (* 2 (/ 1000 3)) (* 2 (/ 1000 3)))
                                          (make-posn 500 500)
                                          (/ 1000 3)))

;; Functions :

;; sierpinski-carpet : Number -> Image
;; Shows the iteration of the Sierpinski Carpet

(define (sierpinski-carpet num)
  (big-bang num
    [to-draw draw-carpet]
    [on-key update-world]))

;; draw-carpet: Number -> Image
;; draws the sierpinski carpet in the world program

(check-expect (draw-carpet 0) (overlay (square (/ 1000 3)
                                               "solid"
                                               "black")
                                       (square 1000
                                               "solid"
                                               "white")))

(define (draw-carpet num)
  (draw-white-squares-to-all (generate-iterations (list SQUARE-FRAC-BACKGROUND) num)))

;; draw-white-squares-to-all: [List-of Square-frac] -> Image
;; draws the middle square in white of all the square partition of the carpet

(check-expect (draw-white-squares-to-all (list SQUARE-FRAC-BACKGROUND)) (overlay (square (/ 1000 3)
                                                                                         "solid"
                                                                                         "black")
                                                                                 (square 1000
                                                                                         "solid"
                                                                                         "white")))

(define (draw-white-squares-to-all losf)
  (local [(define (draw-white-square-to-all/acc losf acc)
            (cond
              [(empty? losf) acc]
              [else (draw-white-square-to-all/acc (rest losf)
                                                  (draw-white-square (first losf)
                                                                     acc))]))]
    (draw-white-square-to-all/acc losf BACKGROUND)))

;; draw-white-square : Square-frac -> Image
;; draws the middle square in white

(check-expect (draw-white-square SQUARE-FRAC-BACKGROUND BACKGROUND) (overlay (square (/ 1000 3)
                                                                                     "solid"
                                                                                     "black")
                                                                             (square 1000
                                                                                     "solid"
                                                                                     "white")))

(define (draw-white-square square-frac previous-image)
  (place-image (square (square-frac-size (middle-square square-frac))
                       "solid"
                       "black")
               (posn-x (square-frac-center (middle-square square-frac)))
               (posn-y (square-frac-center (middle-square square-frac)))
               previous-image))

;; generate-iterations : [List-of Square-frac] Num -> [List-of Square-frac]
;; generates iterations of the fractal based on the input number

(check-expect (generate-iterations (list SQUARE-FRAC-BACKGROUND) 0) (list SQUARE-FRAC-BACKGROUND))
(check-expect (generate-iterations (list SQUARE-FRAC-BACKGROUND) 1) (list SQUARE-FRAC-BACKGROUND
                                                                          SQUARE-FRAC-1
                                                                          SQUARE-FRAC-2
                                                                          SQUARE-FRAC-3
                                                                          SQUARE-FRAC-4
                                                                          SQUARE-FRAC-6
                                                                          SQUARE-FRAC-7
                                                                          SQUARE-FRAC-8
                                                                          SQUARE-FRAC-9))

(define (generate-iterations losf num)
  (local [(define (generate-iterations/loc losf num start)
            (cond
              [(zero? num) losf]
              [else (generate-iterations/loc
                     (append losf
                             (foldr append
                                    empty
                                    (map next-iteration-squares
                                         (rest-num-list losf
                                                        (geometric-sequence-power-of-8 start)))))
                     (sub1 num)
                     (add1 start))]))]
    (generate-iterations/loc losf num -1)))

;; rest-num-list : List Number -> List
;; gives the rest of the list based on the position input
;; with the number being smaller than the length of the list

(check-expect (rest-num-list (list "hello" "world" "fractal" "sierpinski" "carpet") 0)
              (list "hello" "world" "fractal" "sierpinski" "carpet"))
(check-expect (rest-num-list (list "hello" "world" "fractal" "sierpinski" "carpet") 3)
              (list "sierpinski" "carpet"))

(define (rest-num-list l num)
  (cond
    [(zero? num) l]
    [else (rest-num-list (rest l) (sub1 num))]))

;; geometric-sequence-power-of-8 : Number -> Number
;; computes the result of a geometric sequence of ratio 8

(check-expect (geometric-sequence-power-of-8 0) 1)
(check-expect (geometric-sequence-power-of-8 1) 9)
(check-expect (geometric-sequence-power-of-8 2) 73)

(define (geometric-sequence-power-of-8 num)
  (cond
    [(= -1 num) 0]
    [else (local [(define (geometric-sequence/acc num acc)
                    (cond
                      [(zero? num) acc]
                      [else (geometric-sequence/acc (sub1 num) (+ (8-power-to-num num) acc))]))]
            (geometric-sequence/acc num 1))]))
 
;; 8-power-to-num : Number -> Number
;; gives the power of 8 to the number input

(check-expect (8-power-to-num 0) 1)
(check-expect (8-power-to-num 1) 8)
(check-expect (8-power-to-num 3) 512)

(define (8-power-to-num num)
  (cond
    [(= -1 num) 0]
    [(zero? num) 1]
    [else (* 8 (8-power-to-num (sub1 num)))]))


;; next-iteration-squares : Square-frac -> [List-of Square-frac]
;; gives all the 8 squares of the next iteration of a square in the fractal

(check-expect (next-iteration-squares SQUARE-FRAC-BACKGROUND) (list SQUARE-FRAC-1
                                                                    SQUARE-FRAC-2
                                                                    SQUARE-FRAC-3
                                                                    SQUARE-FRAC-4
                                                                    SQUARE-FRAC-6
                                                                    SQUARE-FRAC-7
                                                                    SQUARE-FRAC-8
                                                                    SQUARE-FRAC-9))

(define (next-iteration-squares square-frac)
  (list (top-left-square square-frac)
        (top-middle-square square-frac)
        (top-right-square square-frac)
        (middle-left-square square-frac)
        (middle-right-square square-frac)
        (bottom-left-square square-frac)
        (bottom-middle-square square-frac)
        (bottom-right-square square-frac)))

;; top-left-square : Square-frac -> Square-frac
;; gives the top left square of the next iteration

(check-expect (top-left-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-1)

(define (top-left-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              0)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              0))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              0))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              0)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             0)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             0))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                1)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                1))
                    (/ (square-frac-size square-frac) 3)))
                             
;; top-middle-square : Square-frac -> Square-frac
;; gives the top middle square of the next iteration

(check-expect (top-middle-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-2)

(define (top-middle-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              0))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              0))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             1)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             0))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                2)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                1))
                    (/ (square-frac-size square-frac) 3)))

;; top-right-square : Square-frac -> Square-frac
;; gives the top right square of the next iteration

(check-expect (top-right-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-3)

(define (top-right-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              0))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              3)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              0))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              3)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             2)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             0))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                3)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                1))
                    (/ (square-frac-size square-frac) 3)))
  
;; middle-left-square : Square-frac -> Square-frac
;; gives the middle left square of the next iteration

(check-expect (middle-left-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-4)

(define (middle-left-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              0)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              0)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             0)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             1))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                1)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                2))
                    (/ (square-frac-size square-frac) 3)))

;; midlle-right-square : Square-frac -> Square-frac
;; gives the middle right square of the next iteration

(check-expect (middle-right-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-6)

(define (middle-right-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              3)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              3)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             2)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             1))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                3)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                2))
                    (/ (square-frac-size square-frac) 3)))

;; bottom-left-square : Square-frac -> Square-frac
;; gives the middle right square of the next iteration

(check-expect (bottom-left-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-7)

(define (bottom-left-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              0)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              0)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              3))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              3))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             0)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             2))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                1)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                3))
                    (/ (square-frac-size square-frac) 3)))

;; bottom-middle-square : Square-frac -> Square-frac
;; gives the middle right square of the next iteration

(check-expect (bottom-middle-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-8)

(define (bottom-middle-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              3))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              3))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             1)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             2))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                2)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                3))
                    (/ (square-frac-size square-frac) 3)))

;; bottom-right-square : Square-frac -> Square-frac
;; gives the middle right square of the next iteration

(check-expect (bottom-right-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-9)

(define (bottom-right-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              3)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              3))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              3)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              3))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             2)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             2))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                3)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                3))
                    (/ (square-frac-size square-frac) 3)))

;; mid-square : Square-frac -> Square-frac
;; gives the middle square of the next iteration

(check-expect (middle-square SQUARE-FRAC-BACKGROUND) SQUARE-FRAC-MID)

(define (middle-square square-frac)
  (make-square-frac (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              1))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              1)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (make-posn (calc-distance (posn-x (square-frac-top-left square-frac))
                                              (posn-x (square-frac-top-right square-frac))
                                              2)
                               (calc-distance (posn-y (square-frac-top-left square-frac))
                                              (posn-y (square-frac-bottom-left square-frac))
                                              2))
                    (find-center (make-posn (calc-distance
                                             (posn-x (square-frac-top-left square-frac))
                                             (posn-x (square-frac-top-right square-frac))
                                             1)
                                            (calc-distance
                                             (posn-y (square-frac-top-left square-frac))

                                             (posn-y (square-frac-bottom-left square-frac))
                                             1))
                                 (calc-distance (posn-x (square-frac-top-left square-frac))
                                                (posn-x (square-frac-top-right square-frac))
                                                2)
                                 (calc-distance (posn-y (square-frac-top-left square-frac))
                                                (posn-y (square-frac-bottom-left square-frac))
                                                2))
                    (/ (square-frac-size square-frac) 3)))

;; calc-distance : Number Number Number -> Number
;; calculate necessary distance between two points

(check-expect (calc-distance 0 240 2) 160)
(check-expect (calc-distance 0 240 3) 240)

(define (calc-distance length-1 length-2 times)
  (cond
    [(zero? times) length-1]
    [else (+ (/ (- length-2 length-1) 3) (calc-distance length-1 length-2 (sub1 times)))]))

;; find-center : Number Number Number -> Posn
;; finds the center of a squares based on his three pointa

(check-expect (find-center (make-posn 0 0) 240 240) (make-posn 120 120))
(check-expect (find-center (make-posn 0 0) 80 80) (make-posn 40 40))
(check-expect (find-center (make-posn 80 0) 160 80) (make-posn 120 40))

(define (find-center posn-1 length-2 length-3)
  (make-posn (+ (posn-x posn-1) (/ (- length-2 (posn-x posn-1)) 2))
             (+ (posn-y posn-1) (/ (- length-3 (posn-y posn-1)) 2))))

;; update-world : Number KE -> Number
;; updates world state and changes number by one or minus one using the arrows

(check-expect (update-world 1 "right") 2)
(check-expect (update-world 4 "left") 3)
(check-expect (update-world 2 " ") 2)

(define (update-world num ke)
  (cond
    [(key=? ke "right") (add1 num)]
    [(key=? ke "left") (sub1 num)]
    [else num]))



;; call simulation
(sierpinski-carpet 0)

  











  
  
             










   