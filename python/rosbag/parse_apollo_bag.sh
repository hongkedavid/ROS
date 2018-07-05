# Dump ros bag files with binary output
python dumpbag.py demo.bag demobag_out/ --raw_bag=True

# Decode protocol buffer message
cd /apollo/
/usr/local/bin/protoc --decode=apollo.drivers.gnss.Gnss modules/drivers/gnss/proto/gnss.proto < gnss_msg.bin > gnss_msb.pb.txt

# Encode protocol buffer message
cd /apollo/
/usr/local/bin/protoc --encode=apollo.drivers.gnss.Gnss modules/drivers/gnss/proto/gnss.proto < gnss_msb.pb.txt > gnss_msg.bin

# Generate python API for protocol buffer
# Ref: https://developers.google.com/protocol-buffers/docs/reference/python-generated
/usr/local/bin/protoc --proto_path=src --python_out=build src/header.proto

# Generate C++ API for protocol buffer
# Ref: https://developers.google.com/protocol-buffers/docs/reference/cpp-generated
/usr/local/bin/protoc --proto_path=src --cpp_out=build src/header.proto

# Dump ros bag files with binary output
python writebag.py demo.bag demo.np.bag --raw_bag=True
