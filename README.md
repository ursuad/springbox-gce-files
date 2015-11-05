# Files for the Google Container Engine tutorial
TODO: add link to the blog post

Currently, the directory structure looks like this:

    .
    ├── README.md
    ├── external
    │   ├── expose-api-gateway-service.yaml
    │   ├── expose-auth-server-service.yaml
    │   ├── expose-catalog-service.yaml
    │   ├── expose-config-server-service.yaml
    │   ├── expose-eureka-service.yaml
    │   ├── expose-mongodb-frontend-service.yaml
    │   ├── expose-neo4j-frontend-service.yaml
    │   ├── expose-rabbit-frontend-service.yaml
    │   ├── expose-recommendations-service.yaml
    │   └── expose-reviews-service.yaml
    ├── internal
    │   ├── auth-server-app.yaml
    │   ├── config-server-springbox-app.yaml
    │   ├── curlpod.yaml
    │   ├── eureka-app.yaml
    │   ├── mongodb-app.yaml
    │   ├── neo4j-app.yaml
    │   ├── rabbitmq-app.yaml
    │   ├── springbox-api-gateway.yaml
    │   ├── springbox-catalog-app.yaml
    │   ├── springbox-recommendations-app.yaml
    │   └── springbox-reviews-app.yaml
    └── scripts
        ├── get_hosts_entry.sh
        ├── recommendations
        │   ├── loadGraph.sh
        │   ├── loadLikes.sh
        │   ├── loadMovies.sh
        │   └── loadPeople.sh
        ├── reviews
        │   └── loadReviews.sh
        └── run_all_data.sh

In the **internal** folder you have the files for creating the services and replication controllers.
In the **external** folder you have files which give you the possibility to expose services to the outside world.
In the **scripts** folder you have scripts to add some data.