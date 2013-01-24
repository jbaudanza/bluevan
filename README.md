# Deploying on EC2

Pick an AMI. http://uec-images.ubuntu.com/releases/quantal/release/

Startup user-data

    #!/bin/sh
    curl https://gist.github.com/raw/4515888/75f207ae31ac841bbb0c25fffd9204380938f4dd/user-data.sh | bash -ex

Checkout ruby buildpacks

    su - app
    cd ~/buildpacks
    git clone git://github.com/heroku/heroku-buildpack-ruby.git
    git clone git://github.com/heroku/heroku-buildpack-python.git
    git clone git://github.com/heroku/heroku-buildpack-nodejs.git

Create git repos on server

    git init --bare repos/myproject

Setting the postgres password

    psql postgres
    ALTER USER app WITH PASSWORD 'app';

Link the post-receive hook

    ln -s ~/slugs/bluevan/post-receive.rb repos/myproject/hooks/post-receive

Locally

    git clone bluevan.net:repos/myproject
    # or
    git remote add bluevan app@bluevan.net:repos/myproject

    git push bluevan master

Generate upstart scripts

    sudo foreman export --app myproject --port 6000 --user=app --root=~app/slugs/myproject upstart /etc/init

    sudo start myproject

Start nginx

    sudo service nginx start

Sample nginx config

    upstream jonborg {
      server localhost:6000;
    }

    proxy_set_header  X-Real-IP  $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header  Host $http_host;

    proxy_redirect off;

    server {
      server_name jonb.org www.jonb.org;

      root /home/app/slugs/jonborg/public/;

      location / {
        if (!-f $request_filename) {
          proxy_pass http://jonborg;
        }
      }
    }