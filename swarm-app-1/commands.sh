docker network create --driver overlay frontend_net
docker network create --driver overlay backend_net
docker service create --name voting-app --replicas 2 --network frontend_net -p 80:80 bretfisher/examplevotingapp_vote
docker service create --name redis --replicas 1 --network frontend_net redis:3.2
docker service create --name worker --replicas 1 --network frontend_net --network backend_net bretfisher/examplevotingapp_worker:java
docker service create --name db --replicas 1 --network backend_net --mount type=volume,source=db-data,target=/var/lib/postgresql/data -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.4
docker service create --name result-app --replicas 1 --network backend_net -p 5001:80 bretfisher/examplevotingapp_result