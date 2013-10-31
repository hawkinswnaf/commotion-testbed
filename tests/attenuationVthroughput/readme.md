This performs a throughput test between two nodes. The transmitter is NODE_A 
and the receiver is NODE_B. The values for these variables should be 
the node's ip addresses. Thescript sources ../ip_addrs.sh so that is a 
good place to set the values of those variables. 

All commands are invoked on the nodes using ssh and the results are gathered
with scp. This means that you should make sure that the host running this
script can access the nodes without user intervention (i.e., place the host's
public key on NODE_A and NODE_B.).

The script requires that iperf be available on both nodes and that the 
nodes can communicate with one another over TCP. This means that strict
firewall rules may need to be adjusted.

The raw data from the test is put into ./attenuation_output.txt and then
run through an awk script to convert it to wiki-compatible format. 
