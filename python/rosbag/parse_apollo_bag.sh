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

# Compile a C++ program invoking protobuf C++ API 
# Ref: https://stackoverflow.com/questions/39261897/c-protobuf-undefined-reference-to-constructor-destructor
g++ -I /apollo/bazel-genfiles/ -o $bin $src /apollo/bazel-genfiles/modules/routing/proto/routing.pb.cc /apollo/bazel-genfiles/modules/common/proto/header.pb.cc /apollo/bazel-genfiles/modules/common/proto/geometry.pb.cc /apollo/bazel-genfiles/modules/common/proto/error_code.pb.cc -lprotobuf

# Parse *.pb.txt 
cd /apollo
s1=$(ls -l bazel-apollo | cut -d'.' -f1 | cut -d'>' -f2 | cut -d' ' -f2)
s2=$(ls -l bazel-apollo | cut -d'.' -f2)
dir=$(echo "$s1.$s2")
n=$(echo $dir | grep -o '/' | wc -l);
build_dir=$(echo $dir | cut -d'/' -f1-$(($n-1)))
g++ -std=c++11 -I /apollo/bazel-genfiles/ -I /apollo/ -I $build_dir/external/com_google_protobuf/src/ -o test test.c /apollo/bazel-genfiles/modules/planning/proto/planning.pb.cc /apollo/bazel-genfiles/modules/routing/proto/routing.pb.cc /apollo/bazel-genfiles/modules/canbus/proto/chassis.pb.cc /apollo/bazel-genfiles/modules/common/proto/drive_state.pb.cc /apollo/bazel-genfiles/modules/common/proto/geometry.pb.cc /apollo/bazel-genfiles/modules/common/proto/header.pb.cc /apollo/bazel-genfiles/modules/common/proto/pnc_point.pb.cc /apollo/bazel-genfiles/modules/common/proto/vehicle_signal.pb.cc /apollo/bazel-genfiles/modules/common/proto/error_code.pb.cc /apollo/bazel-genfiles/modules/localization/proto/localization.pb.cc /apollo/bazel-genfiles/modules/localization/proto/pose.pb.cc /apollo/bazel-genfiles/modules/planning/proto/decision.pb.cc /apollo/bazel-genfiles/modules/planning/proto/planning_internal.pb.cc /apollo/bazel-genfiles/modules/planning/proto/sl_boundary.pb.cc /apollo/bazel-genfiles/modules/map/relative_map/proto/navigation.pb.cc /apollo/bazel-genfiles/modules/perception/proto/perception_obstacle.pb.cc /apollo/bazel-genfiles/modules/perception/proto/traffic_light_detection.pb.cc /apollo/bazel-genfiles/modules/map/proto/map.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_clear_area.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_lane.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_speed_bump.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_crosswalk.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_overlap.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_speed_control.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_geometry.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_stop_sign.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_id.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_road.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_yield_sign.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_junction.pb.cc /apollo/bazel-genfiles/modules/map/proto/map_signal.pb.cc -lprotobuf -lglog
