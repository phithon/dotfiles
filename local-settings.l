(setf *filer-directories*
      (list
       (cons "HOME" (si:getenv "USERPROFILE"))
       (cons "git" (merge-pathnames "git" (si:getenv "USERPROFILE")))
       (cons "workspaces" (merge-pathnames "workspaces" (si:getenv "USERPROFILE")))
       (cons "Desktop" (get-special-folder-location :desktop))
       (cons "xyzzy" (si:system-root))))
