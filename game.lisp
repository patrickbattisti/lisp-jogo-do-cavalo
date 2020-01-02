;;board-order
(defun bo()
  '(
    (0 1 2 3 4 -1 6 7 8 9)
    (10 11 12 13 14 15 16 17 18 19)
    (20 21 22 23 24 25 26 27 28 29)
    (30 31 32 33 34 35 36 37 38 39)
    (40 41 42 43 44 45 46 47 48 49)
    (50 51 52 53 54 55 56 57 58 59)
    (60 61 62 63 64 65 66 67 68 69)
    (70 71 72 73 74 75 76 77 78 79)
    (80 81 82 83 84 85 86 87 88 89)
    (90 91 92 93 94 95 96 -2 98 99)
    )
)

(defun position-chess-to-indexes (position)
"returns a positition converted into a line and column indexes"
	(list (- (char-code (character (string-upcase (subseq position 0 1)))) 65) (parse-integer (remove (character (subseq position 0 1)) position)))
)

(let ((player -1))
  (defun jogar (state time)
    (negamax state time player)

    (cond
      ((equal player -1) (setf player -2))
      (t (setf player -1))
    )
  )
)

(defun negamax (state time player)

)



(defun remove-simmetric-assimmetric (value board &optional (strategy 'max))
  (let* (
         (simmetric (reverse (write-to-string value)))
         )

    (cond
     ((null value) board)
     ((< value 10) (remove-node (* value 10) board))
     ((equal (parse-integer simmetric)  value) (remove-node (asymmetric-value board strategy) board))
     (t (remove-node (parse-integer simmetric) board))
     )
    )
  )

(defun asymmetric-value (board &optional (strategy 'max))
  (let* (
         (min-max (asymmetric-values board))
         )

    (cond ((null min-max) nil)
          (t (apply strategy min-max))
          )
    )
)

(defun asymmetric-values (board)
  (apply #'append
         (mapcar
          (lambda (n)
            (cond
             ((or (not (typep n 'real)) (< n 10)) nil)
             ((not(equal (parse-integer (reverse (write-to-string n)))  n)) nil)

             (t (list n))
             )
            )

          (remove-nil-value board)
          )
				)
  )

	(defun remove-nil-value (board)
  (apply #'append
         (mapcar
          (lambda (lin)
            (apply #'append
                   (mapcar
                    (lambda (n)
                      (cond
                       ((or (not (typep n 'real))) nil)
                       (t (list n))
                       )
                      )
                    lin )
                   )
            )
          board)
         )
  )

(defun remove-node (value board)
    (let* (
           (line-column (position-node value board))
           )

      (cond ((or (null (first line-column)) (null (second line-column))) board)
            (t (replace-value (first line-column) (second line-column) board))
            )
      )
    )


(defun position-node (value board)
  (let* (
         (line (line-node value board))
         )

    (list (position line board :test #'equal) (position value line :test #'equal))
    )
  )

(defun line-node (value board)
  (apply #'append
         (mapcar
          (lambda (lin)
            (cond
             ((position value lin :test #'equal) lin)
             (T nil)
             )
            )
          board
       )
    )
  )

(defun replace-position (column-index line &optional (val nil))
  (cond
   ( (null line) '())
   ( (eq column-index 0) (cons val (cdr line)))
   ( (cons (car line) (replace-position (- column-index 1) (cdr line) val))))
  )


(defun replace-value (line-index column-index board &optional (val nil))
  (cond
   ( (null board) '())
   ( (eq line-index 0) (cons (replace-position column-index (nth line-index board) val) (cdr board)))
   ( (cons (car board) (replace-value (- line-index 1) column-index (cdr board) val))))
  )
