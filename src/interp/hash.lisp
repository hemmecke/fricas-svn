;; Copyright (c) 1991-2002, The Numerical ALgorithms Group Ltd.
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are
;; met:
;;
;;     - Redistributions of source code must retain the above copyright
;;       notice, this list of conditions and the following disclaimer.
;;
;;     - Redistributions in binary form must reproduce the above copyright
;;       notice, this list of conditions and the following disclaimer in
;;       the documentation and/or other materials provided with the
;;       distribution.
;;
;;     - Neither the name of The Numerical ALgorithms Group Ltd. nor the
;;       names of its contributors may be used to endorse or promote products
;;       derived from this software without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
;; IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
;; TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;; PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
;; OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;; EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;; PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;; PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


(in-package "VMLISP")

(export '(MAKE-HASHTABLE HGET HKEYS HCOUNT HPUT HPUT* HREM HCLEAR HREMPROP
          HASHEQ HASHUEQUAL HASHCVEC HASHID HASHTABLEP CVEC UEQUAL ID HPUTPROP
          HASHTABLE-CLASS))

;17.0 Operations on Hashtables
;17.1 Creation

(defun MAKE-HASHTABLE (id1 &optional (id2 nil))
 (declare (ignore id2))
   (let ((test (case id1
                     ((EQ ID) #'eq)
                     (CVEC #'equal)
                     (EQL #'eql)
                     #+Lucid ((UEQUAL EQUALP) #'EQUALP)
                     #-Lucid ((UEQUAL EQUAL) #'equal)
                     (otherwise (error "bad arg to make-hashtable")))))     
      (make-hash-table :test test)))

;17.2 Accessing

(defmacro HGET (table key &rest default)
   `(gethash ,key ,table ,@default))

(defun HKEYS (table)
   (let (keys)
      (maphash
        #'(lambda (key val) (declare (ignore val)) (push key keys)) table)
        keys))

#-:CCL
(define-function 'HASHTABLE-CLASS #'hash-table-test)

#+:CCL
(defun HASHTABLE-CLASS (table)
  (case (hashtable-flavour table)
        (0 'EQ)
        (1 'EQL)
        (2 'EQUAL)
        (t (format nil "error unknown hash table class ~a" (hashtable-flavour table)))))

(define-function 'HCOUNT #'hash-table-count)

;17.4 Searching and Updating

(defun HPUT (table key value) (setf (gethash key table) value))

(defun HPUT* (table alist)
  (mapc #'(lambda (pair) (hput table (car pair) (cdr pair))) alist))

(defmacro HREM (table key) `(remhash ,key ,table))

(defun HREMPROP (table key property)
  (let ((plist (gethash key table)))
    (if plist (setf (gethash key table)
                    (delete property plist :test #'equal :key #'car)))))

;17.5 Updating

(define-function 'HCLEAR #'clrhash)

;17.6 Miscellaneous

(define-function 'HASHTABLEP #'hash-table-p)

(define-function 'HASHEQ #'sxhash)

(define-function 'HASHUEQUAL #'sxhash)

(define-function 'HASHCVEC #'sxhash)

(define-function 'HASHID #'sxhash)