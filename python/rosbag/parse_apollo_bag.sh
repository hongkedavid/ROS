# Dump ros bag files with binary output
python dumpbag.py demo.bag demobag_out/ --raw_bag=True

# Decode protocol buffer message
/usr/local/bin/protoc --decode=apollo.drivers.gnss.Gnss gnss.proto < gnss_msg.bin > gnss_msb.pb.txt

# Encode protocol buffer message
/usr/local/bin/protoc --encode=apollo.drivers.gnss.Gnss gnss.proto < gnss_msb.pb.txt > gnss_msg.bin

# Generate python API for protocol buffer
/usr/local/bin/protoc --proto_path=src --python_out=build src/header.proto

# Dump ros bag files with binary output
python writebag.py demo.bag demo.np.bag --raw_bag=True

# Generate python API for protobuf
# Ref: https://developers.google.com/protocol-buffers/docs/reference/python-generated
protoc --proto_path=/apollo/modules/common/proto --python_out=build/gen src/foo.proto src/bar/baz.proto
