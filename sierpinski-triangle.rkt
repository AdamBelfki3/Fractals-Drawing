;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname sierpinski-triangle) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  Project  IV  : Sierpinski Triangle  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visualization of the iteration of the Sierpinski Triangle

(require 2htdp/image)
(require 2htdp/universe)

(define BACKGROUND (square 1100 "solid" "white"))

;; Data:

(define-struct triangle-frac [top-edge right-edge left-edge center size])
;; A TriangleFrac is a (make-triangle-frac Posn Posn Posn Posn Number)
;; An equilateral triangle in a plane represented by
;; the x-y coordinates of the three edges of the triangle
;; plus the coordinates of the center
;; plus a side size of the triangle

;; Examples:

(define TRIANGLEFRAC-BACKGROUND (make-triangle-frac (make-posn 550 (- 550 (/ (sqrt (- (sqr 1000)
                                                                                      (sqr 500))) 2)))
                                                    (make-posn 1050 (+ 550 (/ (sqrt (- (sqr 1000)
                                                                                      (sqr 500))) 2)))
                                                    (make-posn 50 (+ 550 (/ (sqrt (- (sqr 1000)
                                                                                     (sqr 500))) 2)))
                                                    (make-posn 550 550)
                                                    1000))
(define TRIANGLEFRAC-1 (make-triangle-frac (make-posn 500 (- 500 (/ (sqrt (- (sqr 900)
                                                                             (sqr 450))) 2)))
                                           (make-posn (- 500 (/ 450 2)) 500)
                                           (make-posn (+ 500 (/ 450 2)) 500)
                                           (make-posn 500 (- 500 (/ (sqrt (- (sqr 450)
                                                                             (sqr (/ 450 2)))) 2)))
                                           450))
(define TRIANGLEFRAC-2 (make-triangle-frac (make-posn (- 500 (/ 450 2)) 500)
                                           (make-posn 500 (+ 500 (/ (sqrt (- (sqr 900)
                                                                             (sqr 450))) 2)))
                                           (make-posn 50 (+ 500 (/ (sqrt (- (sqr 900)
                                                                            (sqr 450))) 2)))
                                           (make-posn (- 500 (/ 450 2)) (+ 500
                                                                           (/ (sqrt
                                                                               (- (sqr 450)
                                                                                  (sqr (/ 450 2))))
                                                                              2)))
                                           450))
(define TRIANGLEFRAC-3 (make-triangle-frac (make-posn (+ 500 (/ 450 2)) 500)
                                           (make-posn 950 (+ 500 (/ (sqrt (- (sqr 900)
                                                                             (sqr 450))) 2)))
                                           (make-posn 500 (+ 500 (/ (sqrt (- (sqr 900)
                                                                             (sqr 450))) 2)))
                                           (make-posn (+ 500 (/ 450 2)) (+ 500
                                                                           (/ (sqrt
                                                                               (- (sqr 450)
                                                                                  (sqr (/ 450 2))))
                                                                              2)))
                                           450))

;; sierpinski-triangle : Num -> Image
;; visualizes the iterations of the Sierpinski Triangle

(define (sierpinski-triangle num)
  (big-bang num
    [to-draw draw-sierpinski-triangle]
    [on-key update-sierpinski-triangle]))
             
  

;; center-coordinates : Posn Number -> Posn
;; computes the coordinates of the center of a triangle based on its size
;; and the coordinates of its top edge

;(check-expect (center-coordinates (make-posn 4 1) 5) (make-posn 4 (+ 1(/ (* 5 (sqrt 3)) 4))))

(define (center-coordinates top-posn size)
  (make-posn (posn-x top-posn)
             (+ (posn-y top-posn)
                (/ (sqrt (- (sqr size) (sqr (/ size 2)))) 2))))

;; top-triangle : TriangleFrac -> TriangleFrac
;; creates the top triangle from the next iteration

;(check-expect (top-triangle TRIANGLEFRAC-BACKGROUND) TRIANGLEFRAC-1)

(define (top-triangle tf)
  (make-triangle-frac (triangle-frac-top-edge tf)
                      (make-posn (+ (/ (triangle-frac-size tf) 4) (posn-x (triangle-frac-top-edge tf)))
                                 (posn-y (triangle-frac-center tf)))
                      (make-posn (- (posn-x (triangle-frac-top-edge tf)) (/ (triangle-frac-size tf) 4))
                                 (posn-y (triangle-frac-center tf)))
                      (center-coordinates (triangle-frac-top-edge tf)
                                          (/ (triangle-frac-size tf) 2))
                      (/ (triangle-frac-size tf) 2)))

;; right-triangle-frac : TriangleFrac -> TriangleFrac
;; creates the right triangle from the next iteration

(define (right-triangle-frac tf)
  (make-triangle-frac (make-posn (- (posn-x (triangle-frac-right-edge tf))
                                    (/ (triangle-frac-size tf) 4))
                                 (posn-y (triangle-frac-center tf)))
                      (triangle-frac-right-edge tf)
                      (make-posn (posn-x (triangle-frac-top-edge tf))
                                 (posn-y (triangle-frac-right-edge tf)))
                      (local [(define TOP-EDGE (make-posn (- (posn-x (triangle-frac-right-edge tf))
                                                             (/ (triangle-frac-size tf) 4))
                                                          (posn-y (triangle-frac-center tf))))]
                        (center-coordinates TOP-EDGE (/ (triangle-frac-size tf) 2)))
                      (/ (triangle-frac-size tf) 2)))

;; left-triangle-frac : TriangleFrac -> TriangleFrac
;; creates the left triangle from the next iteration

(define (left-triangle-frac tf)
  (make-triangle-frac (make-posn (+ (posn-x (triangle-frac-left-edge tf))
                                    (/ (triangle-frac-size tf) 4))
                                 (posn-y (triangle-frac-center tf)))
                      (make-posn (posn-x (triangle-frac-top-edge tf))
                                 (posn-y (triangle-frac-left-edge tf)))
                      (triangle-frac-left-edge tf)
                      (local [(define TOP-EDGE (make-posn (+ (posn-x (triangle-frac-left-edge tf))
                                                             (/ (triangle-frac-size tf) 4))
                                                          (posn-y (triangle-frac-center tf))))]
                             (center-coordinates TOP-EDGE (/ (triangle-frac-size tf) 2)))
                      (/ (triangle-frac-size tf) 2)))

;; make-3-triangles : TriangleFrac -> [List-of TriangleFrac]
;; creates the next 3 triangles iteration of an input triangle

(define (make-3-triangles tf)
  (list (top-triangle tf)
        (right-triangle-frac tf)
        (left-triangle-frac tf)))

;; make-3-triangles-for-all : [List-of TriangleFrac] -> [List-of TriangleFrac]
;; creates the next 3 triangles iteration of all the triangles in the fractal

(define (make-3-triangles-for-all lotf)
  (foldr append empty (map make-3-triangles lotf)))

;; draw-triangle : TriangleFrac Image -> Image
;; draw triangle from a TriangleFrac

(define (draw-triangle tf previous-image)
  (place-image (triangle (triangle-frac-size tf) "solid" "black")
               (posn-x (triangle-frac-center tf))
               (posn-y (triangle-frac-center tf))
               previous-image))

;; draw-all-triangles : [List-of TriangleFrac] -> Image
;; draw all the triangles of an iteration

(define (draw-all-triangles lotf)
  (local [(define (draw-all-triangles/acc lotf acc)
          (cond
            [(empty? lotf) acc]
            [else (draw-all-triangles/acc (rest lotf) (draw-triangle (first lotf) acc))]))]
    (draw-all-triangles/acc lotf BACKGROUND)))

;; generate-iterations : [List-of TriangleFrac] Num -> [List-of TriangleFrac]
;;

(define (generate-iterations lotf num)
  (cond
    [(zero? num) lotf]
    [else (generate-iterations (make-3-triangles-for-all lotf) (sub1 num))]))

;; draw-sierpinski-triangle : Num -> Image
;; draws the iterations of the sierpinski triangle

(define (draw-sierpinski-triangle num)
  (draw-all-triangles (generate-iterations (list TRIANGLEFRAC-BACKGROUND) num)))

;; update-sierpinski-triangle : Num KE -> Num
;; updates the state of world by increasing or decreasing the number of iterations

(define (update-sierpinski-triangle num ke)
  (cond
    [(key=? "left" ke) (sub1 num)]
    [(key=? "right" ke) (add1 num)]
    [else num]))
   
;; Starting up visualization
(sierpinski-triangle 0)
                                 
                      
                                                    
                                                    



                                