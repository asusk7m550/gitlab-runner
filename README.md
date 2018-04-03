# GitLab Runner Docker image
A Dockerized GitLab Runner that automatically registers with the GitLab CI Server

## Usage
The Docker image can run with the next command.

    docker run --detached \
        --name=gitlab-runner
        --restart=always \
        --environment CI_SERVER_URL=http://gitlab.mydomain.com \
        --environment REGISTRATION_TOKEN=XXXXXXXXXX \
        --environment RUNNER_EXECUTOR=kubernetes \
        --environment KUBERNETES_IMAGE=alpine \
        --environment KUBERNETES_NAMESPACE=gitlab \
        --volume=/etc/gitlab-runner:/etc/gitlab-runner

You should also be able to spawn a gitlab-runner on kubernetes with the following yaml file

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: gitlab-runner
      namespace: gitlab
    spec:
      replicas: 1
      selector:
        matchLabels:
          name: gitlab-runner
      template:
        metadata:
          labels:
            name: gitlab-runner
        spec:
          containers:
          - args:
            - run
            image: asusk7m550/gitlab-runner:latest
            imagePullPolicy: Always
            name: gitlab-runner
            volumeMounts:
            - mountPath: /etc/gitlab-runner/certs
              name: cacerts
              readOnly: true
            env:
            - name: CI_SERVER_URL
              value: "http://gitlab.mydomain.com"
            - name: REGISTRATION_TOKEN
              value: "XXXXXXXXXX"
            - name: RUNNER_EXECUTOR
              value: "kubernetes"
            - name: KUBERNETES_PRIVILEGED
              value: "true"
            - name: KUBERNETES_IMAGE
              value: "docker:latest"
            - name: KUBERNETES_NAMESPACE
              value: "gitlab"
            - name: DOCKER_HOST
              value: tcp://localhost:2375
          - image: docker:1.12.6-dind
            imagePullPolicy: Always
            name: dind-daemon
            securityContext:
                privileged: true
            volumeMounts:
            - name: docker-graph-storage
              mountPath: /var/lib/docker
          restartPolicy: Always
          volumes:
          - name: docker-graph-storage
            emptyDir: {}
          - name: cacerts
            hostPath:
              path: /usr/share/ca-certificates/mozilla

To use your own CA, add the CA file as ca.crt to the directory /usr/share/ca-certificates/mozilla on the workers.

## Acknowledgements

This GitLab Runner was derived from GitLab's Runner container

 * [GitLab Runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/)

## Authors

**Jasper Aikema**
+ [jaikema@proserve.nl](jaikema@proserve.nl)
