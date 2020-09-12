while test $# -gt 0; do
           case "$1" in
                -v)
                    shift
                    wantedVersion=$1
                    shift
                    ;;
                 -h)
                    shift
                    host=$1
                    shift
                    ;;
                 -p)
                    shift
                    port=$1
                    shift
                    ;;
                *)
                   echo "$1 is not a recognized flag!"
                    exit 64
                   ;;
          esac
done  

if [ -z "$wantedVersion" ]; then
  wantedVersion="latest"
fi

if [ -z "$host" ]; then
  echo "host is required flag!"
  exit 64
fi

if [ -z "$port" ]; then
  echo "port is required flag!"
  exit 64
fi


version=$(curl -s "http://$host:$port/health-check" | grep -Pom 1 '"version":"\K[^"]*')
echo "$version"

if [[ "$version" != "$wantedVersion" ]]
then
    echo "Not current version!" 1>&2
    exit 64
fi

    echo "Running current version"

$SHELL;