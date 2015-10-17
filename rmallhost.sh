tmp=''
for i in `docker ps -a | awk '{print $1}'`
do
 tmp="$tmp $i"
done
echo $tmp
docker rm -f $tmp
