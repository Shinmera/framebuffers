(in-package #:org.shirakumo.framebuffers.win32)

(pushnew :win32 sb-int:*available-backends*)

(define-condition win32-error (fb:framebuffer-error)
  ()
  (:report (lambda (c s) (format s ""))))

(defmethod fb-int:init-backend ((backend (eql :win32))))

(defmethod fb-int:shutdown-backend ((backend (eql :win32))))

(defmethod fb-int:open-backend ((backend (eql :win32)) &key))

(defclass window (fb:window)
  ())

(defmethod fb:valid-p ((window window)))

(defmethod fb:close ((window window)))

(defmethod fb:close-requested-p ((window window)))

(defmethod fb:width ((window window)))

(defmethod fb:height ((window window)))

(defmethod fb:size ((window window)))

(defmethod (setf fb:size) ((window size) window))

(defmethod fb:location ((window window)))

(defmethod (setf fb:location) ((window location) window))

(defmethod fb:title ((window window)))

(defmethod (setf fb:title) ((window title) window))

(defmethod fb:visible-p ((window window)))

(defmethod (setf fb:visible-p) ((window state) window))

(defmethod fb:maximized-p ((window window)))

(defmethod (setf fb:maximized-p) ((window state) window))

(defmethod fb:iconified-p ((window window)))

(defmethod (setf fb:iconified-p) ((window state) window))

(defmethod fb:clipboard-string ((window window)))

(defmethod (setf fb:clipboard-string) ((window string) window))

(defmethod fb:content-scale ((window window)))

(defmethod fb:buffer ((window window)))

(defmethod fb:swap-buffers ((window window)))

(defmethod fb:process-events ((window window) &key timeout))

(defmethod fb:request-attention ((window window)))
