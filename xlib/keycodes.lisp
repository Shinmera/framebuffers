(in-package #:org.shirakumo.framebuffers.xlib)

(defvar *keytable* NIL)
(defvar *codetable* (make-hash-table :test 'eq))
(defvar *stringtable* (make-hash-table :test 'eql))

;; Fallback translation based on X11 keysyms
(defun translate-keysym (a b)
  (or (case b
        (65456 :kp-0)
        (65457 :kp-1)
        (65458 :kp-2)
        (65459 :kp-3)
        (65460 :kp-4)
        (65461 :kp-5)
        (65462 :kp-6)
        (65463 :kp-7)
        (65464 :kp-8)
        (65465 :kp-9)
        (65452 :kp-decimal)
        (65454 :kp-decimal)
        (65469 :kp-equal)
        (65421 :kp-enter))
      (case a
        (65307 :escape)
        (65289 :tab)
        (65505 :left-shift)
        (65506 :right-shift)
        (65507 :left-control)
        (65508 :right-control)
        (65511 :left-alt)
        (65513 :left-alt)
        (65406 :right-alt)
        (65027 :right-alt)
        (65512 :right-alt)
        (65514 :right-alt)
        (65515 :left-super)
        (65516 :right-super)
        (65383 :menu)
        (65407 :num-lock)
        (65509 :caps-lock)
        (65377 :print-screen)
        (65300 :scroll-lock)
        (65299 :pause)
        (65535 :delete)
        (65288 :backspace)
        (65293 :enter)
        (65360 :home)
        (65367 :end)
        (65365 :page-up)
        (65366 :page-down)
        (65379 :insert)
        (65361 :left)
        (65363 :right)
        (65364 :down)
        (65362 :up)
        (65470 :f1)
        (65471 :f2)
        (65472 :f3)
        (65473 :f4)
        (65474 :f5)
        (65475 :f6)
        (65476 :f7)
        (65477 :f8)
        (65478 :f9)
        (65479 :f10)
        (65480 :f11)
        (65481 :f12)
        (65482 :f13)
        (65483 :f14)
        (65484 :f15)
        (65485 :f16)
        (65486 :f17)
        (65487 :f18)
        (65488 :f19)
        (65489 :f20)
        (65490 :f21)
        (65491 :f22)
        (65492 :f23)
        (65493 :f24)
        (65494 :f25)
        (65455 :kp-divide)
        (65450 :kp-multiply)
        (65453 :kp-subtract)
        (65451 :kp-add)
        (65438 :kp-0)
        (65436 :kp-1)
        (65433 :kp-2)
        (65435 :kp-3)
        (65430 :kp-4)
        (65432 :kp-6)
        (65429 :kp-7)
        (65431 :kp-8)
        (65434 :kp-9)
        (65439 :kp-decimal)
        (65469 :kp-equal)
        (65421 :kp-enter)
        (97 :a)
        (98 :b)
        (99 :c)
        (100 :d)
        (101 :e)
        (102 :f)
        (103 :g)
        (104 :h)
        (105 :i)
        (106 :j)
        (107 :k)
        (108 :l)
        (109 :m)
        (110 :n)
        (111 :o)
        (112 :p)
        (113 :q)
        (114 :r)
        (115 :s)
        (116 :t)
        (117 :u)
        (118 :v)
        (119 :w)
        (120 :x)
        (121 :y)
        (122 :z)
        (49 :1)
        (50 :2)
        (51 :3)
        (52 :4)
        (53 :5)
        (54 :6)
        (55 :7)
        (56 :8)
        (57 :9)
        (48 :0)
        (32 :space)
        (45 :minus)
        (61 :equal)
        (91 :left-bracket)
        (93 :right-bracket)
        (92 :backslash)
        (59 :semicolon)
        (39 :apostrophe)
        (96 :grave-accent)
        (44 :comma)
        (46 :period)
        (47 :slash)
        (60 :world-1))))

(defun xkb-translate-name (name)
  (cond ((string= name "TLDE") :grave-accent)
        ((string= name "AE01") :1)
        ((string= name "AE02") :2)
        ((string= name "AE03") :3)
        ((string= name "AE04") :4)
        ((string= name "AE05") :5)
        ((string= name "AE06") :6)
        ((string= name "AE07") :7)
        ((string= name "AE08") :8)
        ((string= name "AE09") :9)
        ((string= name "AE10") :0)
        ((string= name "AE11") :minus)
        ((string= name "AE12") :equal)
        ((string= name "AD01") :q)
        ((string= name "AD02") :w)
        ((string= name "AD03") :e)
        ((string= name "AD04") :r)
        ((string= name "AD05") :t)
        ((string= name "AD06") :y)
        ((string= name "AD07") :u)
        ((string= name "AD08") :i)
        ((string= name "AD09") :o)
        ((string= name "AD10") :p)
        ((string= name "AD11") :left-bracket)
        ((string= name "AD12") :right-bracket)
        ((string= name "AC01") :a)
        ((string= name "AC02") :s)
        ((string= name "AC03") :d)
        ((string= name "AC04") :f)
        ((string= name "AC05") :g)
        ((string= name "AC06") :h)
        ((string= name "AC07") :j)
        ((string= name "AC08") :k)
        ((string= name "AC09") :l)
        ((string= name "AC10") :semicolon)
        ((string= name "AC11") :apostrophe)
        ((string= name "AB01") :z)
        ((string= name "AB02") :x)
        ((string= name "AB03") :c)
        ((string= name "AB04") :v)
        ((string= name "AB05") :b)
        ((string= name "AB06") :n)
        ((string= name "AB07") :m)
        ((string= name "AB08") :comma)
        ((string= name "AB09") :period)
        ((string= name "AB10") :slash)
        ((string= name "BKSL") :backslash)
        ((string= name "LSGT") :world-1)
        ((string= name "SPCE") :space)
        ((string= name "ESC") :escape)
        ((string= name "RTRN") :enter)
        ((string= name "TAB") :tab)
        ((string= name "BKSP") :backspace)
        ((string= name "INS") :insert)
        ((string= name "DELE") :delete)
        ((string= name "RGHT") :right)
        ((string= name "LEFT") :left)
        ((string= name "DOWN") :down)
        ((string= name "UP") :up)
        ((string= name "PGUP") :page-up)
        ((string= name "PGDN") :page-down)
        ((string= name "HOME") :home)
        ((string= name "END") :end)
        ((string= name "CAPS") :caps-lock)
        ((string= name "SCLK") :scroll-lock)
        ((string= name "NMLK") :num-lock)
        ((string= name "PRSC") :print-screen)
        ((string= name "PAUS") :pause)
        ((string= name "FK01") :f1)
        ((string= name "FK02") :f2)
        ((string= name "FK03") :f3)
        ((string= name "FK04") :f4)
        ((string= name "FK05") :f5)
        ((string= name "FK06") :f6)
        ((string= name "FK07") :f7)
        ((string= name "FK08") :f8)
        ((string= name "FK09") :f9)
        ((string= name "FK10") :f10)
        ((string= name "FK11") :f11)
        ((string= name "FK12") :f12)
        ((string= name "FK13") :f13)
        ((string= name "FK14") :f14)
        ((string= name "FK15") :f15)
        ((string= name "FK16") :f16)
        ((string= name "FK17") :f17)
        ((string= name "FK18") :f18)
        ((string= name "FK19") :f19)
        ((string= name "FK20") :f20)
        ((string= name "FK21") :f21)
        ((string= name "FK22") :f22)
        ((string= name "FK23") :f23)
        ((string= name "FK24") :f24)
        ((string= name "FK25") :f25)
        ((string= name "KP0") :kp-0)
        ((string= name "KP1") :kp-1)
        ((string= name "KP2") :kp-2)
        ((string= name "KP3") :kp-3)
        ((string= name "KP4") :kp-4)
        ((string= name "KP5") :kp-5)
        ((string= name "KP6") :kp-6)
        ((string= name "KP7") :kp-7)
        ((string= name "KP8") :kp-8)
        ((string= name "KP9") :kp-9)
        ((string= name "KPDL") :kp-decimal)
        ((string= name "KPDV") :kp-divide)
        ((string= name "KPMU") :kp-multiply)
        ((string= name "KPSU") :kp-subtract)
        ((string= name "KPAD") :kp-add)
        ((string= name "KPEN") :kp-enter)
        ((string= name "KPEQ") :kp-equal)
        ((string= name "LFSH") :left-shift)
        ((string= name "LCTL") :left-control)
        ((string= name "LALT") :left-alt)
        ((string= name "LWIN") :left-super)
        ((string= name "RTSH") :right-shift)
        ((string= name "RCTL") :right-control)
        ((string= name "RALT") :right-alt)
        ((string= name "LVL3") :right-alt)
        ((string= name "MDSW") :right-alt)
        ((string= name "RWIN") :right-super)
        ((string= name "MENU") :menu)))

(defun xkb-lookup-key (desc i)
  (let* ((names (xlib:xkb-desc-names desc))
         (aliases (xlib:xkb-names-key-aliases names))
         (name (cffi:foreign-string-to-lisp (cffi:mem-aptr (xlib:xkb-names-keys names) '(:struct xlib:xkb-key) i) :max-chars 4)))
    (or (xkb-translate-name name)
        (dotimes (i (xlib:xkb-names-num-key-aliases names))
          (let ((alias (cffi:mem-aptr aliases '(:struct xlib:xkb-alias) i)))
            (when (string= name (cffi:foreign-string-to-lisp alias :max-chars 4))
              (let ((transl (xkb-translate-name (cffi:foreign-string-to-lisp alias :offset 4 :max-chars 4))))
                (when transl (return transl)))))))))

(defun init-keytable (display xkb)
  (let ((array (make-array 256))
        (table (make-hash-table :test 'eq))
        (min 0) (max 0))
    (cond (xkb
           (let ((desc (xlib:xkb-get-map display 0 #x100)))
             (xlib:xkb-get-names display (logior (ash 1 9) (ash 1 10)) desc)
             (setf min (xlib:xkb-desc-min-key-code desc))
             (setf max (xlib:xkb-desc-max-key-code desc))
             (loop for i from min to max
                   do (setf (aref array i) (xkb-lookup-key desc i)))
             (xlib:xkb-free-names desc (ash 1 9) T)
             (xlib:xkb-free-keyboard desc 0 T)))
          (T
           (cffi:with-foreign-objects ((minptr :uchar) (maxptr :uchar))
             (xlib:display-keycodes display minptr maxptr)
             (setf min (cffi:mem-ref minptr :uchar))
             (setf max (cffi:mem-ref maxptr :uchar)))))
    (cffi:with-foreign-objects ((widthptr :int))
      (let ((keysyms (xlib:get-keyboard-mapping display min (1+ (- max min)) widthptr))
            (width (cffi:mem-ref widthptr :int)))
        (loop for i from min to max
              do (unless (aref array i)
                   (let ((base (* width (- i min))))
                     (setf (aref array i) (translate-keysym (cffi:mem-aref keysyms :int base)
                                                            (when (< 1 width)
                                                              (cffi:mem-aref keysyms :int (1+ base))))))))
        (xlib:free keysyms)))
    (loop for i from 0 below (length array)
          for key = (aref array i)
          do (when key (setf (gethash key table) i)))
    (setf *keytable* array)
    (setf *codetable* table)))

(defun make-stringtable (&optional (table (make-hash-table :test 'eql)))
  (with-open-file (file (fb-int:static-file "xlib/keysyms.txt"))
    (loop for keysym = (read file NIL)
          for codepoint = (read file NIL)
          while keysym
          do (setf (gethash keysym table) (string (code-char codepoint))))
    table))

(make-stringtable)

(defun translate-keycode (code)
  (when (<= 0 code 255)
    (aref *keytable* code)))

(defun keysym-string (code)
  (cond ((= #x1000000 (logand code #xff000000))
         (string (code-char (logand code #xffffff))))
        (T
         (gethash code *stringtable*))))

(defun key-code (key)
  (gethash key *codetable*))
