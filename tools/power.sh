. ../common/nodes.sh

function usage {
cat <<END_OF_USAGE
$0 [power]
END_OF_USAGE
}

if [ $# -ne 1 ]; then
	usage
	exit
fi

power=$( tr '[:upper:]' '[:lower:]'<<<$1 )
if [[ $power != "auto" ]]; then
	power="fixed $1"
fi

for i in $NODES
do
	echo "Setting power for $NODE_BASE.$i"
	ssh root@$NODE_BASE.$i "iw phy phy0 set txpower $power"
done
