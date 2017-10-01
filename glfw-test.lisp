;;;; glfw-test.lisp
;;;;
;;;; Copyright (c) 2017 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>

(in-package #:glfw-test)

(def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignorable window scancode mod-keys))
  (format t "Keypress: ~a ~a ~a ~a ~a~%" window key scancode action mod-keys)
  (cond ((and (eq key :escape) (eq action :press))
         (set-window-should-close))))

(def-mouse-button-callback mouse-handler (window button action mod-keys)
  (declare (ignorable window button action mod-keys))
  (let ((cpos (glfw:get-cursor-position window)))
    (format t "Mouse click at ~a ~a ~a ~a ~a~%" cpos window button action mod-keys)))

(def-scroll-callback scroll-handler (window x y)
  (let ((cpos (glfw:get-cursor-position window)))
    (format t "Scroll at ~a ~a ~a ~a ~%" cpos window x y)))

(def-error-callback error-callback (message)
  (format t "Error: ~a~%" message))

(defun render-scene ()
  (gl:enable :line-smooth
             :polygon-smooth
             :cull-face
             :depth-test :depth-clamp
             :blend)
  (gl:depth-range -10.1 10.1)
  (gl:blend-func :one :one-minus-src-alpha)
  (gl:clear-color 0.0 0.0 0.0 1.0)
  (gl:clear :color-buffer :depth-buffer))

(defun viewer-thread-function ()
  (with-init
    (let* ((monitor (glfw:get-primary-monitor))
           (cur-mode (glfw:get-video-mode monitor))
           (cur-width (getf cur-mode '%cl-glfw3:width))
           (cur-height (getf cur-mode '%cl-glfw3:height)))
      (with-window (:title "OpenGL Scene Viewer"
                           :width (/ cur-width 2)
                           :height (/ cur-height 2)
                           :decorated t
                           ;; :monitor monitor
                           :opengl-profile :opengl-core-profile
                           :context-version-major 3
                           :context-version-minor 3
                           :opengl-forward-compat t
                           :resizable t)
        (setf %gl:*gl-get-proc-address* #'get-proc-address)
        (set-key-callback 'quit-on-escape)
        (set-error-callback 'error-callback)
        (set-mouse-button-callback 'mouse-handler)
        (set-scroll-callback 'scroll-handler)
        (gl:clear-color 0 0 0 1.0)

        ;; The event loop
        (loop until (window-should-close-p)
           do
             (render-scene)
           do (swap-buffers)
           do (poll-events))))))

(defun show-viewer (&optional (in-thread nil))
  (if in-thread
      (viewer-thread-function)
      (trivial-main-thread:with-body-in-main-thread ()
        (viewer-thread-function))))
