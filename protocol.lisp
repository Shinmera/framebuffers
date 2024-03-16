(in-package #:org.shirakumo.framebuffers.int)

;;; Window info
(defgeneric valid-p (window))
(defgeneric close (window))
(defgeneric close-requested-p (window))
(defgeneric width (window))
(defgeneric height (window))
(defgeneric size (window))
(defgeneric (setf size) (size window))
(defgeneric minimum-size (window))
(defgeneric (setf minimum-size) (value window))
(defgeneric maximum-size (window))
(defgeneric (setf maximum-size) (value window))
(defgeneric location (window))
(defgeneric (setf location) (location window))
(defgeneric title (window))
(defgeneric (setf title) (title window))
(defgeneric visible-p (window))
(defgeneric (setf visible-p) (state window))
(defgeneric maximized-p (window))
(defgeneric (setf maximized-p) (state window))
(defgeneric iconified-p (window))
(defgeneric (setf iconified-p) (state window))
(defgeneric focused-p (window))
(defgeneric (setf focused-p) (value window))
(defgeneric borderless-p (window))
(defgeneric (setf borderless-p) (value window))
(defgeneric always-on-top-p (window))
(defgeneric (setf always-on-top-p) (value window))
(defgeneric resizable-p (window))
(defgeneric (setf resizable-p) (value window))
(defgeneric floating-p (window))
(defgeneric (setf floating-p) (value window))
(defgeneric mouse-entered-p (window))
(defgeneric clipboard-string (window))
(defgeneric (setf clipboard-string) (string window))
(defgeneric content-scale (window))
(defgeneric buffer (window))
(defgeneric swap-buffers (window &key x y w h sync))
(defgeneric process-events (window &key timeout))
(defgeneric request-attention (window))
(defgeneric mouse-location (window))
(defgeneric mouse-button-pressed-p (button window))
(defgeneric key-pressed-p (key window))
(defgeneric key-scan-code (key window))
(defgeneric local-key-string (key window))

;;; Event callbacks
(defgeneric window-moved (event-handler xpos ypos))
(defgeneric window-resized (event-handler width height))
(defgeneric window-refreshed (event-handler))
(defgeneric window-focused (event-handler focused-p))
(defgeneric window-iconified (event-handler iconified-p))
(defgeneric window-maximized (event-handler maximized-p))
(defgeneric window-closed (event-handler))
(defgeneric mouse-button-changed (event-handler button action modifiers))
(defgeneric mouse-moved (event-handler xpos ypos))
(defgeneric mouse-entered (event-handler entered-p))
(defgeneric mouse-scrolled (event-handler xoffset yoffset))
(defgeneric key-changed (event-handler key scan-code action modifiers))
(defgeneric string-entered (event-handler string))
(defgeneric file-dropped (event-handler paths))
(defgeneric content-scale-changed (window xscale yscale))

;;; TODO:
;;;; Cursor capturing
;; (defgeneric cursor-state (window))
;; (defgeneric (setf cursor-state) (value window))
;;
;;;; Icons API for cursors and windows
;; (defgeneric icon (window))
;; (defgeneric (setf icon) (value window))
;; (defgeneric cursor-icon (window))
;; (defgeneric (setf cursor-icon) (value window))
;;
;;;; Monitor API to allow fullscreening
;; (defgeneric fullscreen-p (window))
;; (defgeneric (setf fullscreen-p) (value window))
;; (defgeneric list-monitors ())
;; (defgeneric list-modes (monitor))
;; (defgeneric monitor (window))
;; (defgeneric (setf monitor) (value window))
;;
;;;; Input Method support

;;; Backend Internals
(defvar *here* #.(make-pathname :name NIL :type NIL :defaults (or *compile-file-pathname* *load-pathname* (error "Need compile-file or load."))))
(defvar *windows-table* (make-hash-table :test 'eql))
(defvar *available-backends* ())
(defvar *backend* NIL)

(defgeneric init-backend (backend))
(defgeneric shutdown-backend (backend))
(defgeneric open-backend (backend &key))

(defun static-file (path)
  (merge-pathnames path *here*))

(defun default-title ()
  (format NIL "Framebuffer (~a ~a)" (lisp-implementation-type) (lisp-implementation-version)))

(declaim (inline ptr-int))
(defun ptr-int (ptr)
  (etypecase ptr
    (cffi:foreign-pointer (cffi:pointer-address ptr))
    ((integer 1) ptr)))

(declaim (inline ptr-window))
(defun ptr-window (ptr)
  (gethash (ptr-int ptr) *windows-table*))

(defun (setf ptr-window) (window ptr)
  (if window
      (setf (gethash (ptr-int ptr) *windows-table*) window)
      (remhash (ptr-int ptr) *windows-table*))
  window)

(defun list-windows ()
  (loop for window being the hash-values of *windows-table*
        collect window))

;;; Setup
(define-condition framebuffer-error (error)
  ((window :initarg :window :initform NIL :reader window)))

(defun init ()
  (dolist (backend *available-backends*)
    (handler-case
        (progn (init-backend backend)
               (setf *backend* backend)
               (return-from init backend))
      (error ())))
  (if *available-backends*
      (error "Tried to configure ~{~a~^, ~a~}, but none would start properly." *available-backends*)
      (error "There are no available backends for your system.")))

(defun shutdown ()
  (when *backend*
    (dolist (window (list-windows))
      (ignore-errors (close window)))
    (shutdown-backend (shiftf *backend* NIL))
    (clrhash *windows-table*)))

;;; Base class
(defclass window ()
  ((event-handler :initform (make-instance 'event-handler) :accessor event-handler)
   (mouse-location :initform (cons 0 0) :accessor mouse-location)
   (key-states :initform (make-array 356 :element-type 'bit) :accessor key-states)
   (mouse-states :initform (make-array 10 :element-type 'bit) :accessor mouse-states)))

(defmethod initialize-instance :after ((window window) &key event-handler)
  (setf (event-handler window) event-handler))

(defclass event-handler ()
  ((window :initform NIL :initarg :window :accessor window)))

(defmethod (setf event-handler) :before ((handler event-handler) (window window))
  (setf (window handler) window))

(defun open (&rest args &key size location title visible-p &allow-other-keys)
  (declare (ignore size location title visible-p))
  (apply #'open-backend (or *backend* (init)) args))

(defmethod print-object ((window window) stream)
  (print-unreadable-object (window stream :type T :identity T)
    (if (valid-p window)
        (format stream "~dx~d" (width window) (height window))
        (format stream "CLOSED"))))

(defmethod mouse-button-pressed-p (button (window window))
  (< 0 (sbit (mouse-states window) (case button
                                     (:left 0)
                                     (:right 1)
                                     (:middle 2)
                                     (T (+ 3 button))))))

(defmethod key-pressed-p ((scancode integer) (window window))
  (when (<= 0 scancode 355)
    (< 0 (sbit (key-states window) scancode))))

(defmethod key-pressed-p ((key symbol) (window window))
  (let ((scancode (key-scan-code key window)))
    (when (<= 0 scancode 355)
      (< 0 (sbit (key-states window) scancode)))))

;;; Impls
(defmethod window-moved ((window window) xpos ypos)
  (window-moved (event-handler window) xpos ypos))

(defmethod window-resized ((window window) width height)
  (window-resized (event-handler window) width height))

(defmethod window-refreshed ((window window))
  (window-refreshed (event-handler window)))

(defmethod window-focused ((window window) focused-p)
  (unless focused-p
    (fill (mouse-states window) 0)
    (fill (key-states window) 0))
  (window-focused (event-handler window) focused-p))

(defmethod window-iconified ((window window) iconified-p)
  (window-iconified (event-handler window) iconified-p))

(defmethod window-maximized ((window window) maximized-p)
  (window-maximized (event-handler window) maximized-p))

(defmethod window-closed ((window window))
  (window-closed (event-handler window)))

(defmethod mouse-button-changed ((window window) button action modifiers)
  (let ((scan-code (case button
                     (:left 0)
                     (:right 1)
                     (:middle 2)
                     (T (+ 3 button)))))
    (case action
      (:press (setf (sbit (mouse-states window) scan-code) 1))
      (:release (setf (sbit (mouse-states window) scan-code) 0))))
  (mouse-button-changed (event-handler window) button action modifiers))

(defmethod mouse-moved ((window window) xpos ypos)
  (setf (car (mouse-location window)) xpos)
  (setf (car (mouse-location window)) ypos)
  (mouse-moved (event-handler window) xpos ypos))

(defmethod mouse-entered ((window window) entered-p)
  (mouse-entered (event-handler window) entered-p))

(defmethod mouse-scrolled ((window window) xoffset yoffset)
  (mouse-scrolled (event-handler window) xoffset yoffset))

(defmethod key-changed ((window window) key scan-code action modifiers)
  (when (<= 0 scan-code 355)
    (case action
      (:press (setf (sbit (key-states window) scan-code) 1))
      (:release (setf (sbit (key-states window) scan-code) 0))))
  (key-changed (event-handler window) key scan-code action modifiers))

(defmethod string-entered ((window window) string)
  (string-entered (event-handler window) string))

(defmethod file-dropped ((window window) paths)
  (file-dropped (event-handler window) paths))

(defmethod window-moved ((handler event-handler) xpos ypos))
(defmethod window-resized ((handler event-handler) width height))
(defmethod window-refreshed ((handler event-handler)))
(defmethod window-focused ((handler event-handler) focused-p))
(defmethod window-iconified ((handler event-handler) iconified-p))
(defmethod window-maximized ((handler event-handler) maximized-p))
(defmethod window-closed ((handler event-handler)))
(defmethod mouse-button-changed ((handler event-handler) button action modifiers))
(defmethod mouse-moved ((handler event-handler) xpos ypos))
(defmethod mouse-entered ((handler event-handler) entered-p))
(defmethod mouse-scrolled ((handler event-handler) xoffset yoffset))
(defmethod key-changed ((handler event-handler) key scan-code action modifiers))
(defmethod string-entered ((handler event-handler) string))
(defmethod file-dropped ((handler event-handler) paths))

(defclass dynamic-event-handler (event-handler)
  ((handler :initarg :handler :accessor handler)))

(defmethod window-moved ((handler dynamic-event-handler) xpos ypos)
  (funcall (handler handler) 'window-moved (window handler) xpos ypos))
(defmethod window-resized ((handler dynamic-event-handler) width height)
  (funcall (handler handler) 'window-resized (window handler) width height))
(defmethod window-refreshed ((handler dynamic-event-handler))
  (funcall (handler handler) 'window-refreshed (window handler)))
(defmethod window-focused ((handler dynamic-event-handler) focused-p)
  (funcall (handler handler) 'window-focused (window handler) focused-p))
(defmethod window-iconified ((handler dynamic-event-handler) iconified-p)
  (funcall (handler handler) 'window-iconified (window handler) iconified-p))
(defmethod window-maximized ((handler dynamic-event-handler) maximized-p)
  (funcall (handler handler) 'window-maximized (window handler) maximized-p))
(defmethod window-closed ((handler dynamic-event-handler))
  (funcall (handler handler) 'window-closed (window handler)))
(defmethod mouse-button-changed ((handler dynamic-event-handler) button action modifiers)
  (funcall (handler handler) 'mouse-button-changed (window handler) button action modifiers))
(defmethod mouse-moved ((handler dynamic-event-handler) xpos ypos)
  (funcall (handler handler) 'mouse-moved (window handler) xpos ypos))
(defmethod mouse-entered ((handler dynamic-event-handler) entered-p)
  (funcall (handler handler) 'mouse-entered (window handler) entered-p))
(defmethod mouse-scrolled ((handler dynamic-event-handler) xoffset yoffset)
  (funcall (handler handler) 'mouse-scrolled (window handler) xoffset yoffset))
(defmethod key-changed ((handler dynamic-event-handler) key scan-code action modifiers)
  (funcall (handler handler) 'key-changed (window handler) key scan-code action modifiers))
(defmethod string-entered ((handler dynamic-event-handler) string)
  (funcall (handler handler) 'string-entered (window handler) string))
(defmethod file-dropped ((handler dynamic-event-handler) paths)
  (funcall (handler handler) 'file-dropped (window handler) paths))

(defmacro with-window ((window &rest initargs) &body handlers)
  (let ((handle (gensym "HANDLE"))
        (event-type (gensym "EVENT-TYPE"))
        (args (gensym "ARGS")))
    `(flet ((,handle (,event-type ,window &rest ,args)
              (case ,event-type
                ,@(loop for (type lambda-list . body) in handlers
                        collect (if (eql T type)
                                    `(,type (destructuring-bind ,lambda-list (list* ,event-type ,args)
                                              ,@body))
                                    `(,type (destructuring-bind ,lambda-list ,args
                                              ,@body)))))))
       (let ((,window (open :event-handler (make-instance 'dynamic-event-handler :handler #',handle) ,@initargs)))
         (unwind-protect
              (loop initially (,handle 'init ,window)
                    finally (,handle 'shutdown ,window)
                    until (close-requested-p ,window)
                    do (process-events ,window :timeout T))
           (close ,window))))))

(trivial-indent:define-indentation with-window
    (4 &rest (&whole 2 6 &body)))

(defun resize-buffer (w h &optional old-buffer ow oh)
  (let ((buffer (static-vectors:make-static-vector (* 4 w h) :initial-element 0)))
    (when old-buffer
      ;; Copy sub-region back.
      ;; TODO: scale it instead
      (dotimes (y (min h oh))
        (dotimes (x (min w ow))
          (dotimes (z 4)
            (setf (aref buffer (+ z (* 4 (+ x (* w y)))))
                  (aref old-buffer (+ z (* 4 (+ x (* ow y)))))))))
      (static-vectors:free-static-vector old-buffer))
    buffer))

(defmacro do-pixels ((buf i x y) window &body body)
  (let ((wg (gensym "WIDTH"))
        (hg (gensym "HEIGHT"))
        (win (gensym "WINDOW")))
    `(let* ((,i 0)
            (,win ,window)
            (,buf (buffer ,win)))
       (destructuring-bind (,wg . ,hg) (size ,win)
         (declare (type (simple-array (unsigned-byte 8) (*)) ,buf))
         (declare (type (unsigned-byte 32) ,i ,wg ,hg))
         (dotimes (,y ,hg ,buf)
           (dotimes (,x ,wg)
             (progn ,@body)
             (incf ,i 4)))))))

(defmacro with-cleanup (cleanup &body body)
  (let ((ok (gensym "OK")))
    `(let ((,ok NIL))
       (unwind-protect
            (multiple-value-prog1 (progn ,@body)
              (setf ,ok T))
         (unless ,ok
           ,cleanup)))))
