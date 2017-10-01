;;;; glfw-test.asd
;;;;
;;;; Copyright (c) 2017 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>

(asdf:defsystem #:glfw-test
  :description "Minimal GLFW3 application for experimenting."
  :author "Jeremiah LaRocco <jeremiah_larocco@fastmail.com>"
  :license "ISC (BSD-like)"
  :depends-on (#:alexandria
               #:cl-glfw3
               #:cl-opengl
               #:bordeaux-threads
               #:trivial-main-thread
               #:3d-vectors
               #:3d-matrices)
  :serial t
  :components ((:file "package")
               (:file "glfw-test")))

