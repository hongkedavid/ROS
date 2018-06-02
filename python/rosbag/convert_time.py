import argparse
import datetime

def convert_time_to_ts(t_sec):
	print datetime.datetime.fromtimestamp(t_sec).strftime('%Y-%m-%d-%H:%M:%S.%f')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=
        "Convert time from ms to time stamp")
    parser.add_argument(
        "t_sec", action="store", type=float, help="the input time(ms)")
    args = parser.parse_args()
    convert_time_to_ts(args.t_sec)
