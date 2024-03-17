(defpackage #:org.shirakumo.framebuffers
  (:use #:cl)
  (:shadow #:open #:close)
  (:export
   #:framebuffer-error
   #:window
   #:display
   #:event-handler
   #:dynamic-event-handler
   #:icon
   #:touchpoint
   #:radius
   #:angle
   #:pressure
   #:video-mode
   #:refresh-rate
   #:init
   #:shutdown
   #:open
   #:with-window
   #:do-pixels
   #:clear
   #:valid-p
   #:close-requested-p
   #:close
   #:width
   #:height
   #:minimum-size
   #:maximum-size
   #:size
   #:location
   #:title
   #:visible-p
   #:maximized-p
   #:iconified-p
   #:focused-p
   #:borderless-p
   #:always-on-top-p
   #:resizable-p
   #:floating-p
   #:mouse-entered-p
   #:clipboard-string
   #:content-scale
   #:buffer
   #:swap-buffers
   #:process-events
   #:request-attention
   #:mouse-location
   #:mouse-button-pressed-p
   #:key-pressed-p
   #:key-scan-code
   #:local-key-string
   #:icon
   #:cursor-icon
   #:cursor-state
   #:fullscreen-p
   #:set-timer
   #:cancel-timer
   #:display
   #:primary-p
   #:video-modes
   #:video-mode
   #:id
   #:list-displays
   #:window-moved
   #:window-resized
   #:window-refreshed
   #:window-focused
   #:window-iconified
   #:window-maximized
   #:window-closed
   #:mouse-button-changed
   #:mouse-moved
   #:mouse-entered
   #:mouse-scrolled
   #:key-changed
   #:string-entered
   #:file-dropped
   #:content-scale-changed
   #:touch-started
   #:touch-moved
   #:touch-ended
   #:touch-cancelled
   #:pen-moved
   #:timer-triggered))

(defpackage #:org.shirakumo.framebuffers.int
  (:use #:cl #:org.shirakumo.framebuffers)
  (:local-nicknames
   (#:fb #:org.shirakumo.framebuffers))
  (:shadowing-import-from
   #:org.shirakumo.framebuffers
   #:open #:close #:make-touchpoint #:make-video-mode)
  (:shadow
   #:close-requested-p
   #:minimum-size
   #:maximum-size
   #:size
   #:location
   #:title
   #:visible-p
   #:maximized-p
   #:iconified-p
   #:focused-p
   #:borderless-p
   #:always-on-top-p
   #:resizable-p
   #:floating-p
   #:mouse-entered-p
   #:fullscreen-p
   #:primary-p
   #:content-scale
   #:icon
   #:cursor-icon
   #:cursor-state
   #:radius
   #:angle
   #:pressure
   #:display
   #:id)
  (:export
   #:*available-backends*
   #:make-touchpoint
   #:make-video-mode
   #:static-file
   #:init-backend
   #:shutdown-backend
   #:open-backend
   #:list-displays-backend
   #:default-title
   #:ptr-int
   #:ptr-window
   #:list-windows
   #:resize-buffer
   #:close-requested-p
   #:minimum-size
   #:maximum-size
   #:size
   #:location
   #:title
   #:visible-p
   #:maximized-p
   #:iconified-p
   #:focused-p
   #:borderless-p
   #:always-on-top-p
   #:resizable-p
   #:floating-p
   #:mouse-entered-p
   #:fullscreen-p
   #:primary-p
   #:content-scale
   #:icon
   #:cursor-icon
   #:cursor-state
   #:radius
   #:angle
   #:pressure
   #:display
   #:id
   #:with-cleanup
   #:clean))
