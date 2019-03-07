###Hello World docker image###

**Build the image**

    docker build -t welcome .
    docker run -it welcome /bin/sh

**Login to docker hub or quay.io**

    docker login -u eformat -p <password> docker.io
    docker login -u "eformat" -p <password> quay.io

**Tag the image**

    docker tag welcome docker.io/eformat/welcome
    docker tag welcome quay.io/eformat/welcome

**Push the image**

    docker push docker.io/eformat/welcome
    docker push quay.io/eformat/welcome

**Pull the image**

    docker pull docker.io/eformat/welcome
    docker pull quay.io/eformat/welcome

