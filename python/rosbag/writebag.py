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
This program can dump a rosbag into separate text files that contains the pb messages
"""

import rosbag
import std_msgs
import argparse
import shutil
import os
import sys

from std_msgs.msg import String

import chassis_pb2 as chassis

def write_bag(in_bag, out_bag, start_time, duration, filter_topic, raw_bag):
    """out_bag = in_bag + routing_bag"""
    bag = rosbag.Bag(in_bag, 'r')
    seq = 0
    with rosbag.Bag(out_bag, 'w') as f:
      for topic, msg, t in bag.read_messages(raw=raw_bag):
        t_sec = t.secs + t.nsecs / 1.0e9;
        if start_time and t_sec < start_time:
            print "not yet reached the start time"
            continue
        if start_time and t_sec >= start_time + duration:
            print "done"
            break
        if topic == "/apollo/sensor/mobileye":
            continue
        if not filter_topic or topic == filter_topic:
            #print "export at time ", t
            if seq > 3000 and topic == "/apollo/canbus/chassis":
               l = len(msg[1])
               read_chassis = chassis.Chassis()
               read_chassis.ParseFromString(msg[1][4:])
               if read_chassis.driving_mode == 1:
                  read_chassis.driving_mode = 0
               nstr = read_chassis.SerializeToString()
               msg = (msg[0], msg[1][0:4] + read_chassis.SerializeToString(), msg[2], msg[3], msg[4])
               if l != len(msg[1]):
                  print('modify error on msg %d' % seq)
                  return
            f.write(topic, msg, t, raw_bag)
        seq += 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=
        "A tool to modify the protobuf messages dumpped from a ros bag")
    parser.add_argument(
        "in_rosbag", action="store", type=str, help="the input ros bag")
    parser.add_argument(
        "--start_time", action="store", type=float, help="the input ros bag")
    parser.add_argument(
        "--duration", action="store", type=float, default=1.0, help="the input ros bag")
    parser.add_argument(
        "out_rosbag", action="store", type=str, help="the output ros bag")
    parser.add_argument(
        "--topic",
        action="store",
        help="""the topic that you want to dump. If this option is not provided,
        the tool will dump all the messages regardless of the message topic."""
    )
    parser.add_argument(
        "--raw_bag", action="store", type=bool, default=False, help="the input ros bag")
    args = parser.parse_args()

    write_bag(args.in_rosbag, args.out_rosbag, args.start_time, args.duration, args.topic, args.raw_bag)
