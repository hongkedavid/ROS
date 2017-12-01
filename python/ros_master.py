# Ref: http://wiki.ros.org/ROS/Master_API
from xmlrpclib import ServerProxy
import os

# Get ROS master and its URI
master = ServerProxy(os.environ['ROS_MASTER_URI'])
master.getUri('/')

# Get system states in list representation [publishers, subscribers, services]
# publishers is of the form [ [topic1, [topic1Publisher1...topic1PublisherN]] ... ]
# subscribers is of the form [ [topic1, [topic1Subscriber1...topic1SubscriberN]] ... ]
# services is of the form [ [service1, [service1Provider1...service1ProviderN]] ... ]
ret_val, msg, state = master.getSystemState('/')
for pub in state[0]:
    print pub
for sub in state[1]:
    print sub
for srv in state[2]:
    print srv

# Get the XML-RPC URI of the node
master.lookupNode('/', '/gnss_nodelet_manager')
