(in-package #:org.shirakumo.framebuffers.wayland.cffi)

(cffi:define-foreign-library wayland
  (T (:or (:default "libwayland-client") (:default "wayland-client"))))

;;; core defs
(define-constant MARSHAL-FLAG-DESTROY 1)

(cffi:defcstruct (message :conc-name message-)
  (name :string)
  (signature :string)
  (types :pointer))

(cffi:defcstruct (interface :conc-name interface-)
  (name :string)
  (version :int)
  (method-count :int)
  (methods :pointer)
  (event-count :int)
  (events :pointer))

(cffi:defcunion argument
  (i :int32)
  (u :uint32)
  (f :int32)
  (s :string)
  (o :pointer)
  (n :uint32)
  (a :pointer)
  (h :int32))

(cffi:defcfun (event-queue-destroy "wl_event_queue_destroy") :void
  (queue :pointer))

(cffi:defcfun (proxy-marshal-array-flags "wl_proxy_marshal_array_flags") :pointer
  (proxy :pointer)
  (opcode :uint32)
  (interface :pointer)
  (version :uint32)
  (flags :uint32)
  (args :pointer))

(defun proxy-marshal-flags (proxy opcode interface version flags &rest args)
  (cffi:with-foreign-objects ((arglist '(:union argument) (length args)))
    (loop for i from 0
          for arg in args
          do (setf (cffi:mem-aref arglist '(:union argument) i) arg))
    (proxy-marshal-array-flags proxy opcode interface version flags args)))

(cffi:defcfun (proxy-marshal-array "wl_proxy_marshal_array") :void
  (p :pointer)
  (opcode :uint32)
  (args :pointer))

(defun proxy-marshal (proxy opcode &rest args)
  (cffi:with-foreign-objects ((arglist '(:union argument) (length args)))
    (loop for i from 0
          for arg in args
          do (setf (cffi:mem-aref arglist '(:union argument) i) arg))
    (proxy-marshal-array proxy opcode args)))

(cffi:defcfun (proxy-create "wl_proxy_create") :pointer
  (factory :pointer)
  (interface :pointer))

(cffi:defcfun (proxy-create-wrapper "wl_proxy_create_wrapper") :pointer
  (proxy :pointer))

(cffi:defcfun (proxy-wrapper-destroy "wl_proxy_wrapper_destroy") :void
  (proxy_wrapper :pointer))

(cffi:defcfun (proxy-marshal-array-constructor "wl_proxy_marshal_array_constructor") :pointer
  (proxy :pointer)
  (opcode :uint32)
  (args :pointer)
  (interface :pointer))

(defun proxy-marshal-constructor (proxy opcode interface &rest args)
  (cffi:with-foreign-objects ((arglist '(:union argument) (length args)))
    (loop for i from 0
          for arg in args
          do (setf (cffi:mem-aref arglist '(:union argument) i) arg))
    (proxy-marshal-array-constructor proxy opcode args interface)))

(cffi:defcfun (proxy-marshal-array-constructor-versioned "wl_proxy_marshal_array_constructor_versioned") :pointer
  (proxy :pointer)
  (opcode :uint32)
  (args :pointer)
  (interface :pointer)
  (version :uint32))

(defun proxy-marshal-constructor-versinoed (proxy opcode interface version &rest args)
  (cffi:with-foreign-objects ((arglist '(:union argument) (length args)))
    (loop for i from 0
          for arg in args
          do (setf (cffi:mem-aref arglist '(:union argument) i) arg))
    (proxy-marshal-array-constructor-versioned proxy opcode args interface version)))

(cffi:defcfun (proxy-destroy "wl_proxy_destroy") :void
  (proxy :pointer))

(cffi:defcfun (proxy-add-listener "wl_proxy_add_listener") :int
  (proxy :pointer)
  (implementation :pointer)
  (data :pointer))

(cffi:defcfun (proxy-get-listener "wl_proxy_get_listener") :pointer
  (proxy :pointer))

(cffi:defcfun (proxy-add-dispatcher "wl_proxy_add_dispatcher") :int
  (proxy :pointer)
  (dispatcher_func :pointer)
  (dispatcher_data :pointer)
  (data :pointer))

(cffi:defcfun (proxy-set-user-data "wl_proxy_set_user_data") :void
  (proxy :pointer)
  (user_data :pointer))

(cffi:defcfun (proxy-get-user-data "wl_proxy_get_user_data") :pointer
  (proxy :pointer))

(cffi:defcfun (proxy-get-version "wl_proxy_get_version") :uint32
  (proxy :pointer))

(cffi:defcfun (proxy-get-id "wl_proxy_get_id") :uint32
  (proxy :pointer))

(cffi:defcfun (proxy-set-tag "wl_proxy_set_tag") :void
  (proxy :pointer)
  (tag :pointer))

(cffi:defcfun (proxy-get-tag "wl_proxy_get_tag") :pointer
  (proxy :pointer))

(cffi:defcfun (proxy-get-class "wl_proxy_get_class") :string
  (proxy :pointer))

(cffi:defcfun (proxy-set-queue "wl_proxy_set_queue") :void
  (proxy :pointer)
  (queue :pointer))

(cffi:defcfun (display-connect "wl_display_connect") :pointer
  (name :string))

(cffi:defcfun (display-connect-to-fd "wl_display_connect_to_fd") :pointer
  (fd :int))

(cffi:defcfun (display-disconnect "wl_display_disconnect") :void
  (display :pointer))

(cffi:defcfun (display-get-fd "wl_display_get_fd") :int
  (display :pointer))

(cffi:defcfun (display-dispatch "wl_display_dispatch") :int
  (display :pointer))

(cffi:defcfun (display-dispatch-queue "wl_display_dispatch_queue") :int
  (display :pointer)
  (queue :pointer))

(cffi:defcfun (display-dispatch-queue-pending "wl_display_dispatch_queue_pending") :int
  (display :pointer)
  (queue :pointer))

(cffi:defcfun (display-dispatch-pending "wl_display_dispatch_pending") :int
  (display :pointer))

(cffi:defcfun (display-get-error "wl_display_get_error") :int
  (display :pointer))

(cffi:defcfun (display-get-protocol-error "wl_display_get_protocol_error") :uint32
  (display :pointer)
  (interface :pointer)
  (id :pointer))

(cffi:defcfun (display-flush "wl_display_flush") :int
  (display :pointer))

(cffi:defcfun (display-roundtrip-queue "wl_display_roundtrip_queue") :int
  (display :pointer)
  (queue :pointer))

(cffi:defcfun (display-roundtrip "wl_display_roundtrip") :int
  (display :pointer))

(cffi:defcfun (display-create-queue "wl_display_create_queue") :pointer
  (display :pointer))

(cffi:defcfun (display-prepare-read-queue "wl_display_prepare_read_queue") :int
  (display :pointer)
  (queue :pointer))

(cffi:defcfun (display-prepare-read "wl_display_prepare_read") :int
  (display :pointer))

(cffi:defcfun (display-cancel-read "wl_display_cancel_read") :void
  (display :pointer))

(cffi:defcfun (display-read-events "wl_display_read_events") :int
  (display :pointer))

(cffi:defcfun (log-set-handler-client "wl_log_set_handler_client") :void
  (handler :pointer))

;;; protocol defs
(defconstant DISPLAY-SYNC 0)
(defconstant DISPLAY-GET-REGISTRY 1)
(defconstant DISPLAY-ERROR-SINCE-VERSION 1)
(defconstant DISPLAY-DELETE-ID-SINCE-VERSION 1)
(defconstant DISPLAY-SYNC-SINCE-VERSION 1)
(defconstant DISPLAY-GET-REGISTRY-SINCE-VERSION 1)
(defconstant REGISTRY-BIND 0)
(defconstant REGISTRY-GLOBAL-SINCE-VERSION 1)
(defconstant REGISTRY-GLOBAL-REMOVE-SINCE-VERSION 1)
(defconstant REGISTRY-BIND-SINCE-VERSION 1)
(defconstant CALLBACK-DONE-SINCE-VERSION 1)
(defconstant COMPOSITOR-CREATE-SURFACE 0)
(defconstant COMPOSITOR-CREATE-REGION 1)
(defconstant COMPOSITOR-CREATE-SURFACE-SINCE-VERSION 1)
(defconstant COMPOSITOR-CREATE-REGION-SINCE-VERSION 1)
(defconstant SHM-POOL-CREATE-BUFFER 0)
(defconstant SHM-POOL-DESTROY 1)
(defconstant SHM-POOL-RESIZE 2)
(defconstant SHM-POOL-CREATE-BUFFER-SINCE-VERSION 1)
(defconstant SHM-POOL-DESTROY-SINCE-VERSION 1)
(defconstant SHM-POOL-RESIZE-SINCE-VERSION 1)
(defconstant SHM-CREATE-POOL 0)
(defconstant SHM-FORMAT-SINCE-VERSION 1)
(defconstant SHM-CREATE-POOL-SINCE-VERSION 1)
(defconstant BUFFER-DESTROY 0)
(defconstant BUFFER-RELEASE-SINCE-VERSION 1)
(defconstant BUFFER-DESTROY-SINCE-VERSION 1)
(defconstant DATA-OFFER-ACCEPT 0)
(defconstant DATA-OFFER-RECEIVE 1)
(defconstant DATA-OFFER-DESTROY 2)
(defconstant DATA-OFFER-FINISH 3)
(defconstant DATA-OFFER-SET-ACTIONS 4)
(defconstant DATA-OFFER-OFFER-SINCE-VERSION 1)
(defconstant DATA-OFFER-SOURCE-ACTIONS-SINCE-VERSION 3)
(defconstant DATA-OFFER-ACTION-SINCE-VERSION 3)
(defconstant DATA-OFFER-ACCEPT-SINCE-VERSION 1)
(defconstant DATA-OFFER-RECEIVE-SINCE-VERSION 1)
(defconstant DATA-OFFER-DESTROY-SINCE-VERSION 1)
(defconstant DATA-OFFER-FINISH-SINCE-VERSION 3)
(defconstant DATA-OFFER-SET-ACTIONS-SINCE-VERSION 3)
(defconstant DATA-SOURCE-OFFER 0)
(defconstant DATA-SOURCE-DESTROY 1)
(defconstant DATA-SOURCE-SET-ACTIONS 2)
(defconstant DATA-SOURCE-TARGET-SINCE-VERSION 1)
(defconstant DATA-SOURCE-SEND-SINCE-VERSION 1)
(defconstant DATA-SOURCE-CANCELLED-SINCE-VERSION 1)
(defconstant DATA-SOURCE-DND-DROP-PERFORMED-SINCE-VERSION 3)
(defconstant DATA-SOURCE-DND-FINISHED-SINCE-VERSION 3)
(defconstant DATA-SOURCE-ACTION-SINCE-VERSION 3)
(defconstant DATA-SOURCE-OFFER-SINCE-VERSION 1)
(defconstant DATA-SOURCE-DESTROY-SINCE-VERSION 1)
(defconstant DATA-SOURCE-SET-ACTIONS-SINCE-VERSION 3)
(defconstant DATA-DEVICE-START-DRAG 0)
(defconstant DATA-DEVICE-SET-SELECTION 1)
(defconstant DATA-DEVICE-RELEASE 2)
(defconstant DATA-DEVICE-DATA-OFFER-SINCE-VERSION 1)
(defconstant DATA-DEVICE-ENTER-SINCE-VERSION 1)
(defconstant DATA-DEVICE-LEAVE-SINCE-VERSION 1)
(defconstant DATA-DEVICE-MOTION-SINCE-VERSION 1)
(defconstant DATA-DEVICE-DROP-SINCE-VERSION 1)
(defconstant DATA-DEVICE-SELECTION-SINCE-VERSION 1)
(defconstant DATA-DEVICE-START-DRAG-SINCE-VERSION 1)
(defconstant DATA-DEVICE-SET-SELECTION-SINCE-VERSION 1)
(defconstant DATA-DEVICE-RELEASE-SINCE-VERSION 2)
(defconstant DATA-DEVICE-MANAGER-CREATE-DATA-SOURCE 0)
(defconstant DATA-DEVICE-MANAGER-GET-DATA-DEVICE 1)
(defconstant DATA-DEVICE-MANAGER-CREATE-DATA-SOURCE-SINCE-VERSION 1)
(defconstant DATA-DEVICE-MANAGER-GET-DATA-DEVICE-SINCE-VERSION 1)
(defconstant SHELL-GET-SHELL-SURFACE 0)
(defconstant SHELL-GET-SHELL-SURFACE-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-PONG 0)
(defconstant SHELL-SURFACE-MOVE 1)
(defconstant SHELL-SURFACE-RESIZE 2)
(defconstant SHELL-SURFACE-SET-TOPLEVEL 3)
(defconstant SHELL-SURFACE-SET-TRANSIENT 4)
(defconstant SHELL-SURFACE-SET-FULLSCREEN 5)
(defconstant SHELL-SURFACE-SET-POPUP 6)
(defconstant SHELL-SURFACE-SET-MAXIMIZED 7)
(defconstant SHELL-SURFACE-SET-TITLE 8)
(defconstant SHELL-SURFACE-SET-CLASS 9)
(defconstant SHELL-SURFACE-PING-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-CONFIGURE-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-POPUP-DONE-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-PONG-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-MOVE-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-RESIZE-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-TOPLEVEL-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-TRANSIENT-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-FULLSCREEN-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-POPUP-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-MAXIMIZED-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-TITLE-SINCE-VERSION 1)
(defconstant SHELL-SURFACE-SET-CLASS-SINCE-VERSION 1)
(defconstant SURFACE-DESTROY 0)
(defconstant SURFACE-ATTACH 1)
(defconstant SURFACE-DAMAGE 2)
(defconstant SURFACE-FRAME 3)
(defconstant SURFACE-SET-OPAQUE-REGION 4)
(defconstant SURFACE-SET-INPUT-REGION 5)
(defconstant SURFACE-COMMIT 6)
(defconstant SURFACE-SET-BUFFER-TRANSFORM 7)
(defconstant SURFACE-SET-BUFFER-SCALE 8)
(defconstant SURFACE-DAMAGE-BUFFER 9)
(defconstant SURFACE-OFFSET 10)
(defconstant SURFACE-ENTER-SINCE-VERSION 1)
(defconstant SURFACE-LEAVE-SINCE-VERSION 1)
(defconstant SURFACE-PREFERRED-BUFFER-SCALE-SINCE-VERSION 6)
(defconstant SURFACE-PREFERRED-BUFFER-TRANSFORM-SINCE-VERSION 6)
(defconstant SURFACE-DESTROY-SINCE-VERSION 1)
(defconstant SURFACE-ATTACH-SINCE-VERSION 1)
(defconstant SURFACE-DAMAGE-SINCE-VERSION 1)
(defconstant SURFACE-FRAME-SINCE-VERSION 1)
(defconstant SURFACE-SET-OPAQUE-REGION-SINCE-VERSION 1)
(defconstant SURFACE-SET-INPUT-REGION-SINCE-VERSION 1)
(defconstant SURFACE-COMMIT-SINCE-VERSION 1)
(defconstant SURFACE-SET-BUFFER-TRANSFORM-SINCE-VERSION 2)
(defconstant SURFACE-SET-BUFFER-SCALE-SINCE-VERSION 3)
(defconstant SURFACE-DAMAGE-BUFFER-SINCE-VERSION 4)
(defconstant SURFACE-OFFSET-SINCE-VERSION 5)
(defconstant SEAT-GET-POINTER 0)
(defconstant SEAT-GET-KEYBOARD 1)
(defconstant SEAT-GET-TOUCH 2)
(defconstant SEAT-RELEASE 3)
(defconstant SEAT-CAPABILITIES-SINCE-VERSION 1)
(defconstant SEAT-NAME-SINCE-VERSION 2)
(defconstant SEAT-GET-POINTER-SINCE-VERSION 1)
(defconstant SEAT-GET-KEYBOARD-SINCE-VERSION 1)
(defconstant SEAT-GET-TOUCH-SINCE-VERSION 1)
(defconstant SEAT-RELEASE-SINCE-VERSION 5)
(defconstant POINTER-AXIS-SOURCE-WHEEL-TILT-SINCE-VERSION 6)
(defconstant POINTER-SET-CURSOR 0)
(defconstant POINTER-RELEASE 1)
(defconstant POINTER-ENTER-SINCE-VERSION 1)
(defconstant POINTER-LEAVE-SINCE-VERSION 1)
(defconstant POINTER-MOTION-SINCE-VERSION 1)
(defconstant POINTER-BUTTON-SINCE-VERSION 1)
(defconstant POINTER-AXIS-SINCE-VERSION 1)
(defconstant POINTER-FRAME-SINCE-VERSION 5)
(defconstant POINTER-AXIS-SOURCE-SINCE-VERSION 5)
(defconstant POINTER-AXIS-STOP-SINCE-VERSION 5)
(defconstant POINTER-AXIS-DISCRETE-SINCE-VERSION 5)
(defconstant POINTER-AXIS-VALUE120-SINCE-VERSION 8)
(defconstant POINTER-AXIS-RELATIVE-DIRECTION-SINCE-VERSION 9)
(defconstant POINTER-SET-CURSOR-SINCE-VERSION 1)
(defconstant POINTER-RELEASE-SINCE-VERSION 3)
(defconstant KEYBOARD-RELEASE 0)
(defconstant KEYBOARD-KEYMAP-SINCE-VERSION 1)
(defconstant KEYBOARD-ENTER-SINCE-VERSION 1)
(defconstant KEYBOARD-LEAVE-SINCE-VERSION 1)
(defconstant KEYBOARD-KEY-SINCE-VERSION 1)
(defconstant KEYBOARD-MODIFIERS-SINCE-VERSION 1)
(defconstant KEYBOARD-REPEAT-INFO-SINCE-VERSION 4)
(defconstant KEYBOARD-RELEASE-SINCE-VERSION 3)
(defconstant TOUCH-RELEASE 0)
(defconstant TOUCH-DOWN-SINCE-VERSION 1)
(defconstant TOUCH-UP-SINCE-VERSION 1)
(defconstant TOUCH-MOTION-SINCE-VERSION 1)
(defconstant TOUCH-FRAME-SINCE-VERSION 1)
(defconstant TOUCH-CANCEL-SINCE-VERSION 1)
(defconstant TOUCH-SHAPE-SINCE-VERSION 6)
(defconstant TOUCH-ORIENTATION-SINCE-VERSION 6)
(defconstant TOUCH-RELEASE-SINCE-VERSION 3)
(defconstant OUTPUT-RELEASE 0)
(defconstant OUTPUT-GEOMETRY-SINCE-VERSION 1)
(defconstant OUTPUT-MODE-SINCE-VERSION 1)
(defconstant OUTPUT-DONE-SINCE-VERSION 2)
(defconstant OUTPUT-SCALE-SINCE-VERSION 2)
(defconstant OUTPUT-NAME-SINCE-VERSION 4)
(defconstant OUTPUT-DESCRIPTION-SINCE-VERSION 4)
(defconstant OUTPUT-RELEASE-SINCE-VERSION 3)
(defconstant REGION-DESTROY 0)
(defconstant REGION-ADD 1)
(defconstant REGION-SUBTRACT 2)
(defconstant REGION-DESTROY-SINCE-VERSION 1)
(defconstant REGION-ADD-SINCE-VERSION 1)
(defconstant REGION-SUBTRACT-SINCE-VERSION 1)
(defconstant SUBCOMPOSITOR-DESTROY 0)
(defconstant SUBCOMPOSITOR-GET-SUBSURFACE 1)
(defconstant SUBCOMPOSITOR-DESTROY-SINCE-VERSION 1)
(defconstant SUBCOMPOSITOR-GET-SUBSURFACE-SINCE-VERSION 1)
(defconstant SUBSURFACE-DESTROY 0)
(defconstant SUBSURFACE-SET-POSITION 1)
(defconstant SUBSURFACE-PLACE-ABOVE 2)
(defconstant SUBSURFACE-PLACE-BELOW 3)
(defconstant SUBSURFACE-SET-SYNC 4)
(defconstant SUBSURFACE-SET-DESYNC 5)
(defconstant SUBSURFACE-DESTROY-SINCE-VERSION 1)
(defconstant SUBSURFACE-SET-POSITION-SINCE-VERSION 1)
(defconstant SUBSURFACE-PLACE-ABOVE-SINCE-VERSION 1)
(defconstant SUBSURFACE-PLACE-BELOW-SINCE-VERSION 1)
(defconstant SUBSURFACE-SET-SYNC-SINCE-VERSION 1)
(defconstant SUBSURFACE-SET-DESYNC-SINCE-VERSION 1)

(defun buffer-destroy ())
(defun callback-add-listener ())
(defun callback-destroy ())
(defun compositor-create-surface ())
(defun compositor-destroy ())
(defun cursor-image-get-buffer ())
(defun display-get-registry ())
(defun keyboard-add-listener ())
(defun keyboard-destroy ())
(defun pointer-destroy ())
(defun pointer-set-cursor ())
(defun registry-add-listener ())
(defun registry-bind ())
(defun registry-destroy ())
(defun seat-add-listener ())
(defun seat-destroy ())
(defun shell-destroy ())
(defun shell-get-shell-surface ())
(defun shell-surface-add-listener ())
(defun shell-surface-destroy ())
(defun shell-surface-pong ())
(defun shell-surface-set-title ())
(defun shell-surface-set-toplevel ())
(defun shm-add-listener ())
(defun shm-create-pool ())
(defun shm-destroy ())
(defun shm-pool-create-buffer ())
(defun shm-pool-resize ())
(defun surface-attach ())
(defun surface-commit ())
(defun surface-damage ())
(defun surface-frame ())