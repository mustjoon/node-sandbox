while test $# -gt 0; do
           case "$1" in
                -v)
                    shift
                    wantedVersion=$1
                    shift
                    ;;
                *)
                   echo "$1 is not a recognized flag!"
                   return 1;
                   ;;
          esac
done  

if [ -z "$version" ]; then
  wantedVersion="latest"
fi


version=$(curl -s "http://localhost:8080/health-check" | grep -Pom 1 '"version":"\K[^"]*')
echo "$version"

if [[ "$version" != "$wantedVersion" ]]
then
    echo "Not current version!" 1>&2
    exit 64
fi

    echo "Running current version"