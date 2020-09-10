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



docker build -t mustjoon/hackathon-starter:$version .
docker push mustjoon/hackathon-starter:$version

$SHELL