(load-file "./behave.el")
(load-file "../dbgr-loc.el")
(load-file "../dbgr-lochist.el")

(behave-clear-contexts)

;;; (defun setup()
;;;      (lexical-let ((loc-hist (make-dbgr-loc-hist))
;;; 		   (filename (buffer-file-name (current-buffer)))
;;; 		   (loc (dbgr-loc-current)))
;;;        (dbgr-loc-hist-add loc-hist loc)))
;;;        ;; (message "aa ring-index %s" 
;;;        ;; 		(dbgr-loc-hist-index loc-hist))))

;;; (setup)


(lexical-let ((saved-buffer (current-buffer)))
  ; Below, we need to make sure current-buffer has an associated
  ; file with it.
  (find-file (symbol-file 'behave))

  (context "location ring initialization and fields access"
	   (tag lochist)
	   (lexical-let ((loc-hist (make-dbgr-loc-hist))
			 (filename (buffer-file-name (current-buffer)))
			 (loc (dbgr-loc-current)))
	     
	     (specify "get ring component for a new history ring"
		      (expect-t (ring-p (dbgr-loc-hist-ring loc-hist))))

	     (specify "ring position for an empty history ring is -1"
		      (expect-equal -1 (dbgr-loc-hist-position loc-hist)))

	     (specify "get item for an empty history ring"
		      (expect-nil (dbgr-loc-hist-item loc-hist)))
	     
	     (specify "add an item to an empty history ring"
		      (dbgr-loc-hist-add loc-hist loc)
		      (expect-equal loc (dbgr-loc-hist-item loc-hist)))

	     (specify "One item in history ring"
		      (expect-equal 1 (ring-length 
			       (dbgr-loc-hist-ring loc-hist))))

	     (specify "ring index in history ring is 1"
		      (expect (dbgr-loc-hist-index loc-hist) equal 1))

	     (specify "duplicate item added is ignored"
		      (dbgr-loc-hist-add loc-hist loc)
		      (expect-equal 1 (ring-length 
			       (dbgr-loc-hist-ring loc-hist))))

	     (specify "ring index in history ring after dup ignore is still 1"
		      (expect-equal 1 (dbgr-loc-hist-index loc-hist)))


	     (specify "Set to newest position"
		      (expect-equal -1 (dbgr-loc-hist-newest loc-hist)))
	     
	     ))
  (behave "lochist")
  (switch-to-buffer saved-buffer))

