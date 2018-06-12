# List active ROS nodes
rosnode list

# Ref: http://wiki.ros.org/rostopic
rostopic echo $topic_name
rostopic find $msg_type
rostopic list
rostopic pub $topic_name $msg_type $data
rostopic type $topic_name

# Ref: http://wiki.ros.org/rosmsg
rosmsg show $msg_type
rosmsg list
