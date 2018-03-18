cat control.IFNO | grep "estop 0 te" | grep -v "brake 35" | cut -d' ' -f11,13,15,19,21 > control_trace.out
awk '{print $4, $5, $2-$1";"}' control_trace.out > control_trace.act
awk '{print $4, $5";"}' control_trace.out | uniq > control_trace.loc
rm control_trace.out
