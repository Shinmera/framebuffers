(in-package #:org.shirakumo.framebuffers.wayland.cffi)

(cffi:define-foreign-library wayland
  (T (:or (:default "libwayland-client") (:default "wayland-client"))))

(cffi:defcfun (buffer-destroy "wl_buffer_destroy"))
(cffi:defcfun (callback-add-listener "wl_callback_add_listener"))
(cffi:defcfun (callback-destroy "wl_callback_destroy"))
(cffi:defcfun (compositor-create-surface "wl_compositor_create_surface"))
(cffi:defcfun (compositor-destroy "wl_compositor_destroy"))
(cffi:defcfun (cursor-image-get-buffer "wl_cursor_image_get_buffer"))
(cffi:defcfun (display-connect "wl_display_connect"))
(cffi:defcfun (display-disconnect "wl_display_disconnect"))
(cffi:defcfun (display-dispatch "wl_display_dispatch"))
(cffi:defcfun (display-dispatch-pending "wl_display_dispatch_pending"))
(cffi:defcfun (display-get-error "wl_display_get_error"))
(cffi:defcfun (display-get-registry "wl_display_get_registry"))
(cffi:defcfun (display-roundtrip "wl_display_roundtrip"))
(cffi:defcfun (keyboard-add-listener "wl_keyboard_add_listener"))
(cffi:defcfun (keyboard-destroy "wl_keyboard_destroy"))
(cffi:defcfun (pointer-destroy "wl_pointer_destroy"))
(cffi:defcfun (pointer-set-cursor "wl_pointer_set_cursor"))
(cffi:defcfun (registry-add-listener "wl_registry_add_listener"))
(cffi:defcfun (registry-bind "wl_registry_bind"))
(cffi:defcfun (registry-destroy "wl_registry_destroy"))
(cffi:defcfun (seat-add-listener "wl_seat_add_listener"))
(cffi:defcfun (seat-destroy "wl_seat_destroy"))
(cffi:defcfun (shell-destroy "wl_shell_destroy"))
(cffi:defcfun (shell-get-shell-surface "wl_shell_get_shell_surface"))
(cffi:defcfun (shell-surface-add-listener "wl_shell_surface_add_listener"))
(cffi:defcfun (shell-surface-destroy "wl_shell_surface_destroy"))
(cffi:defcfun (shell-surface-pong "wl_shell_surface_pong"))
(cffi:defcfun (shell-surface-set-title "wl_shell_surface_set_title"))
(cffi:defcfun (shell-surface-set-toplevel "wl_shell_surface_set_toplevel"))
(cffi:defcfun (shm-add-listener "wl_shm_add_listener"))
(cffi:defcfun (shm-create-pool "wl_shm_create_pool"))
(cffi:defcfun (shm-destroy "wl_shm_destroy"))
(cffi:defcfun (shm-pool-create-buffer "wl_shm_pool_create_buffer"))
(cffi:defcfun (shm-pool-resize "wl_shm_pool_resize"))
(cffi:defcfun (surface-attach "wl_surface_attach"))
(cffi:defcfun (surface-commit "wl_surface_commit"))
(cffi:defcfun (surface-damage "wl_surface_damage"))
(cffi:defcfun (surface-frame "wl_surface_frame"))
