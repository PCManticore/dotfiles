(require 'prodigy)

(prodigy-define-service
  :name "content_storage"
  ;; ssh -t qdev "cd ~content_storage; . .env/bin/activate; python manage.py runserver 0.0.0.0:8181"
  :command "ssh"
  :args '("-t" "qdev" "cd ~content_storage; . .env/bin/activate; python manage.py runserver 0.0.0.0:8000")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "admintool"
  ;; ssh -t qdev "cd ~admintool; . .env/bin/activate; python manage.py runserver 0.0.0.0:8282"
  :command "ssh"
  :args '("-t" "qdev" "cd ~admintool; . .env/bin/activate; python manage.py runserver 0.0.0.0:8484")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "publish-api"
  ;; ssh -t qdev "cd ~publish-api/publish-api; make run"
  :command "ssh"
  :args '("-t" "qdev" "cd ~publish-api/publish-api; make run")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "server-thex"
  ;; ssh -t qdev "cd ~publish-api/publish-api; make run"
  :command "ssh"
  :args '("-t" "qdev" "cd ~server_thex; make run")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "mediacontent-back"
  ;; ssh -t qdev "cd ~publish-api/publish-api; make run"
  :command "ssh"
  ;; :args '("-t" "qdev" "cd ~mediacontent; . .env/bin/activate; python mediacontent/server/back.py")
  :args '("-t" "qdev" "cd ~mediacontent; . .env/bin/activate; gunicorn mediacontent.server.back:app -c gunicorn/back.conf")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "mediacontent-front"
  ;; ssh -t qdev "cd ~publish-api/publish-api; make run"
  :command "ssh"
  ;; :args '("-t" "qdev" "cd ~mediacontent; . .env/bin/activate; python mediacontent/server/front.py")
  :args '("-t" "qdev" "cd ~mediacontent; . .env/bin/activate; gunicorn mediacontent.server.front:app -c gunicorn/front.conf")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "db_service"
  ;; ssh -t qdev "cd ~publish-api/publish-api; make run"
  :command "ssh"
  :args '("-t" "qdev" "cd ~db_service; . .env/bin/activate; make run")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "qb_center"
  :command "ssh"
  :args '("-t" "qdev" "cd ~qb_center; . .env/bin/activate; make run")
  :tags '(qbeats)
  :kill-signal 'sigkill
  :kill-process-buffer-on-stop t)

(provide 'demi-prodigy)
