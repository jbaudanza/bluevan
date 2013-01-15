# Deploying on EC2

Pick an AMI. http://uec-images.ubuntu.com/releases/quantal/release/

Startup user-data

    #!/bin/sh
    curl https://gist.github.com/raw/4515888/9632d675d2625bc348539307b570644a2654af76/user-data.sh | bash -ex

Checkout ruby buildpacks

    su - app
    cd ~/buildpacks
    git clone git://github.com/heroku/heroku-buildpack-ruby.git
    git clone git://github.com/heroku/heroku-buildpack-python.git
    git clone git://github.com/heroku/heroku-buildpack-nodejs.git

Create git repos on server

    git init --bare myproject

Link the post-receive hook

Locally

    git clone bluevan.net:repos/myproject
    # or
    git remote add bluevan app@bluevan.net:repos/myproject

    git push bluevan master

Generate upstart scripts

    sudo foreman export --user=app --root=~app/slugs/bluevan upstart /etc/init