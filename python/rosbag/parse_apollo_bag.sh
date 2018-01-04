# Dump ros bag files with binary output
python dumpbag.py demo.bag demobag_out/ --raw_bag=True

# Decode protocol buffer message
/usr/local/bin/protoc --decode=apollo.drivers.gnss.Gnss gnss.proto < gnss_msg.bin > gnss_msb.pb.txt

# Encode protocol buffer message
/usr/local/bin/protoc --encode=apollo.drivers.gnss.Gnss gnss.proto < gnss_msb.pb.txt > gnss_msg.bin
