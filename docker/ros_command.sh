# List active ROS nodes
rosnode list
# To get process ID of a ROS node
# Ref: https://answers.ros.org/question/271776/how-can-i-retrieve-a-list-of-process-ids-of-ros-nodes/
rosnode info $node_name 2>/dev/null | grep Pid | cut -d' ' -f2

# Ref: http://wiki.ros.org/rostopic
rostopic echo $topic_name
rostopic find $msg_type
rostopic list
rostopic pub $topic_name $msg_type $data
rostopic type $topic_name

# Ref: http://wiki.ros.org/rosmsg
rosmsg show $msg_type
rosmsg list
