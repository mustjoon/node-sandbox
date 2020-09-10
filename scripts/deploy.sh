while test $# -gt 0; do
           case "$1" in
                -v)
                    shift
                    version=$1
                    shift
                    ;;
                *)
                   echo "$1 is not a recognized flag!"
                   return 1;
                   ;;
          esac
done  

if [ -z "$version" ]; then
  version="latest"
fi



ssh root@167.71.56.231 <<EOF
docker network create home
docker pull mustjoon/hackathon-starter:$version
docker kill hack
docker rm hack
docker run -d --publish 27017:27017 --network "home"  --name "mongo" mongo:3.6
docker run -d --network "home" --publish 8081:8081 --name="hack" --env "MONGODB_URI=mongodb://mongo:27017/test" mustjoon/hackathon-starter:$version
EOF

$SHELL