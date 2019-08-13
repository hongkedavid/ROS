# Build KLEE source code
# Ref: http://klee.github.io/releases/docs/v1.4.0/build-llvm34/
mkdir /apollo/klee_build_dir
cd /apollo/klee_build_dir
cmake $klee_src_dir -DUSE_CMAKE_FIND_PACKAGE_LLVM=ON
make
sudo make install

# Run KLEE on Apollo
cd /apollo/bazel-bin/modules/planning
klee --libc=uclibc --posix-runtime --link-llvm-lib=/apollo/boost_1_69_0/o_files/boost.bc --link-llvm-lib=liblog4cxx.so.10.0.0.bc --link-llvm-lib=libroconsole_all.bc --link-llvm-lib=dummy.bc planning.bc

# Generate Apollo bitcode
cd /apollo
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/planning:planning --compilation_mode=dbg
cd /apollo/bazel-bin/modules/planning
extract-bc planning

# More on KLEE v2
llvm-link _bisect.so.bc _codecs_cn.so.bc _codecs_hk.so.bc _codecs_iso2022.so.bc _codecs_jp.so.bc _codecs_kr.so.bc _codecs_tw.so.bc _collections.so.bc _csv.so.bc _ctypes.so.bc _ctypes_test.so.bc _curses.so.bc _curses_panel.so.bc _elementtree.so.bc _functools.so.bc _hashlib.so.bc _heapq.so.bc _hotshot.so.bc _io.so.bc _json.so.bc _locale.so.bc _lsprof.so.bc _multibytecodec.so.bc _multiprocessing.so.bc _random.so.bc _sqlite3.so.bc _ssl.so.bc _struct.so.bc _testcapi.so.bc _tkinter.so.bc array.so.bc audioop.so.bc binascii.so.bc bz2.so.bc cPickle.so.bc cStringIO.so.bc cmath.so.bc crypt.so.bc fcntl.so.bc future_builtins.so.bc grp.so.bc itertools.so.bc linuxaudiodev.so.bc math.so.bc mmap.so.bc nis.so.bc operator.so.bc ossaudiodev.so.bc parser.so.bc pyexpat.so.bc resource.so.bc select.so.bc spwd.so.bc strop.so.bc syslog.so.bc termios.so.bc time.so.bc unicodedata.so.bc zlib.so.bc -o python.bc
llvm-link _bisect.so.bc _codecs_cn.so.bc _codecs_hk.so.bc _codecs_iso2022.so.bc _codecs_jp.so.bc _codecs_kr.so.bc _codecs_tw.so.bc _collections.so.bc _csv.so.bc _ctypes.so.bc _ctypes_test.so.bc _curses.so.bc _curses_panel.so.bc _elementtree.so.bc _functools.so.bc _hashlib.so.bc _heapq.so.bc _hotshot.so.bc _io.so.bc _json.so.bc _locale.so.bc _lsprof.so.bc _multibytecodec.so.bc _multiprocessing.so.bc _random.so.bc _sqlite3.so.bc _ssl.so.bc _struct.so.bc _testcapi.so.bc _tkinter.so.bc array.so.bc audioop.so.bc binascii.so.bc bz2.so.bc cPickle.so.bc cStringIO.so.bc cmath.so.bc crypt.so.bc fcntl.so.bc future_builtins.so.bc grp.so.bc itertools.so.bc linuxaudiodev.so.bc mmap.so.bc nis.so.bc operator.so.bc ossaudiodev.so.bc parser.so.bc pyexpat.so.bc resource.so.bc select.so.bc spwd.so.bc strop.so.bc syslog.so.bc termios.so.bc time.so.bc unicodedata.so.bc zlib.so.bc -o python.bc

cd ../../Objects/
for f in *.o; do extract-bc $f; done
cp /apollo/boost_1_69_0/o_files/llvm_link.py .
ls *.bc >> names.txt
python llvm_link.py names.txt 
llvm-link abstract.o.bc boolobject.o.bc bufferobject.o.bc bytearrayobject.o.bc bytes_methods.o.bc capsule.o.bc cellobject.o.bc classobject.o.bc cobject.o.bc codeobject.o.bc complexobject.o.bc descrobject.o.bc dictobject.o.bc enumobject.o.bc exceptions.o.bc fileobject.o.bc floatobject.o.bc frameobject.o.bc funcobject.o.bc genobject.o.bc intobject.o.bc iterobject.o.bc listobject.o.bc longobject.o.bc memoryobject.o.bc methodobject.o.bc moduleobject.o.bc object.o.bc obmalloc.o.bc rangeobject.o.bc setobject.o.bc sliceobject.o.bc stringobject.o.bc structseq.o.bc tupleobject.o.bc typeobject.o.bc unicodectype.o.bc unicodeobject.o.bc weakrefobject.o.bc -o python2.bc
klee --libc=uclibc --posix-runtime --disable-verify --link-llvm-lib=librosconsole.bc --link-llvm-lib=dummy.bc --link-llvm-lib=/apollo/boost_1_69_0/o_files/boost.bc --link-llvm-lib=liblog4cxx.so.10.0.0.bc  --link-llvm-lib=/apollo/Python-2.7.15/build/lib.linux-x86_64-2.7/python.bc --link-llvm-lib=/apollo/Python-2.7.15/Objects/python2.bc --max-memory=8000 planning.bc
