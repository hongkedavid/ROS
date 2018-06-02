#!/usr/bin/env python

###############################################################################
# Copyright 2017 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
"""
This program can add/remove specific pb messages from a rosbag
"""

import rosbag
import std_msgs
import argparse
import shutil
import os
import sys

from std_msgs.msg import String

import pdb
import datetime

import modules.perception.proto.perception_obstacle_pb2 as percept_obs 
from modules.localization.proto import localization_pb2 as localize_pos

def write_to_file(file_path, topic_pb):
    """write pb message to file"""
    f = file(file_path, 'w')
    f.write(str(topic_pb))
    f.close()

def add_static_obs_to_bag(in_bag, out_dir, start_time, duration):
    inbag = rosbag.Bag(in_bag, 'r')
    with rosbag.Bag(out_dir+'.np.bag', 'w') as outbag:
	# setup static perception obstacle
#	p_obs = percept_obs.PerceptionObstacle()
    	for topic, msg, t in inbag.read_messages():
            t_sec = t.secs + t.nsecs / 1.0e9;
            ts = datetime.datetime.fromtimestamp(t_sec).strftime('%Y-%m-%d-%H:%M:%S.%f')
            if start_time and t_sec < start_time:
                print "not yet reached the start time"
                continue
            if start_time and t_sec >= start_time + duration:
                print "done"
                break
            if topic == "/apollo/sensor/mobileye":
                continue
            if topic == "/apollo/perception/obstacles":
	        '''	if len(msg.perception_obstacle) != 0:
			new_copy = msg.perception_obstacle.add()
			new_copy = msg.perception_obstacle[0]
			new_copy.id = 1000
			print msg.perception_obstacle[0]
		'''
                p_obs = msg.perception_obstacle.add()
		p_obs.id = 1000
	
                x = 587560.65
                y = 4140781.43	
		p_obs.position.x = 587560.65
		p_obs.position.y = 4140781.43
		p_obs.position.z = -29.9661701322
		p_obs.theta = 0
		p_obs.velocity.x = 0
		p_obs.velocity.y = 0
		p_obs.velocity.z = 0
		p_obs.length = 3.0
		p_obs.width = 2.0
		p_obs.height = 1.0
		p1 = p_obs.polygon_point.add()
		p1.x = x+p_obs.width/2
		p1.y = y+p_obs.width
		p1.z = -29.9661701322
		p2 = p_obs.polygon_point.add()
		p2.x = x-p_obs.width/2
		p2.y = y+p_obs.width
		p2.z = -29.9661701322
		p3 = p_obs.polygon_point.add()
		p3.x = x-p_obs.width/2
		p3.y = y-p_obs.width
		p3.z = -29.9661701322
		p4 = p_obs.polygon_point.add()
		p4.x = x+p_obs.width/2
		p4.y = y-p_obs.width
		p4.z = -29.9661701322
		
		p_obs.tracking_time = 20.0

		p_obs.type = percept_obs.PerceptionObstacle.VEHICLE
		
		p_obs.timestamp = 0.0
              	outbag.write(topic, msg, t)

                print "export at time ", t_sec
                message_file = topic.replace("/", "_")
                file_path = os.path.join(out_dir,
                                       #message_file + ".pb.txt")
                                       str(ts) + message_file + ".pb.txt")
                write_to_file(file_path, msg)
            else:
                outbag.write(topic, msg, t)

# clean msg for free run
def freerun_clean_bag(in_bag, out_dir, start_time, duration):
    c = 0
    inbag = rosbag.Bag(in_bag, 'r')
    with rosbag.Bag(out_dir+'.freerun.bag', 'w') as outbag:
	is_pose_init = False
    	for topic, msg, t in inbag.read_messages():
            t_sec = t.secs + t.nsecs / 1.0e9;
            ts = datetime.datetime.fromtimestamp(t_sec).strftime('%Y-%m-%d-%H:%M:%S.%f')
            if start_time and t_sec < start_time:
                print "not yet reached the start time"
                continue
            if start_time and t_sec >= start_time + duration:
                print "done"
                break
            if topic == "/apollo/sensor/mobileye":
                continue
            if topic == "/apollo/perception/obstacles":
                outbag.write(topic,msg,t)
              #  print "export at time ", t_sec
                message_file = topic.replace("/", "_")
                file_path = os.path.join(out_dir,
                                       #message_file + ".pb.txt")
                                       str(ts) + message_file + ".pb.txt")
                write_to_file(file_path, msg)
	    if topic == "/apollo/perception/traffic_light":
                outbag.write(topic,msg,t)
              #  print "export at time ", t_sec
                message_file = topic.replace("/", "_")
                file_path = os.path.join(out_dir,
                                       #message_file + ".pb.txt")
                                       str(ts) + message_file + ".pb.txt")
                write_to_file(file_path, msg)
            if topic == "/apollo/localization/pose" and not is_pose_init:
		carx = msg.pose.position.x
                cary = msg.pose.position.y
                carz = msg.pose.position.z
                cartheta = msg.pose.heading
                print "pose init ", t_sec, carx, cary, carz, cartheta, msg.pose.position.x, msg.pose.position.y
                outbag.write(topic,msg,t)
		is_pose_init = True
                message_file = topic.replace("/", "_")
                file_path = os.path.join(out_dir,
                                       #message_file + ".pb.txt")
                                       str(ts) + message_file + ".pb.txt")
                write_to_file(file_path, msg)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=
        "A tool to modify messages in a ros bag")
    parser.add_argument(
        "in_rosbag", action="store", type=str, help="the input ros bag")
    parser.add_argument(
        "--start_time", action="store", type=float, help="the input ros bag")
    parser.add_argument(
        "--duration", action="store", type=float, default=1.0, help="the input ros bag")
    parser.add_argument(
        "out_dir",
        action="store",
        help="the output directory for the new rosbag and dumped file")
    parser.add_argument("--freerun",action="store_true",help="clean rosbag for free run")
    args = parser.parse_args()

    if os.path.exists(args.out_dir+'.np.bag'):
        os.remove(args.out_dir+'.np.bag')
 
    if os.path.exists(args.out_dir):
        shutil.rmtree(args.out_dir)
    os.makedirs(args.out_dir)
    #if args.freerun:
    freerun_clean_bag(args.in_rosbag, args.out_dir, args.start_time, args.duration)
    #else:
    #	add_static_obs_to_bag(args.in_rosbag, args.out_dir, args.start_time, args.duration)
