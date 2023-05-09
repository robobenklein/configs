import argparse
import json
import csv
import socket
from pathlib import Path
import pyudev
from blkinfo import BlkDiskInfo
import pySMART

context = pyudev.Context()
myblkd = BlkDiskInfo()
all_disks = {k["name"]: k for k in myblkd.get_disks()}
pySMART.SMARTCTL.sudo = True

model_names = {
    "WDC  WUH721816ALE6L4": "WD Ultrastar DC HC550 16TB SATA 7.2k 512e/4Kn HDD",
}
model_mfgs = {
    "WDC  WUH721816ALE6L4": "Western Digital",
}
model_roles = {
    "WDC  WUH721816ALE6L4": "SATA 3.5\" HDD",
}

def get_smart_dev(path):
    return pySMART.Device(path)

def get_mapper_paths(dm_path):
    return all_disks[Path(dm_path).stem]["parents"]

def get_udev_dev(path):
    try:
        return pyudev.Devices.from_path(context, path)
    except pyudev._errors.DeviceNotFoundAtPathError as e:
        return pyudev.Devices.from_device_file(context, path)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default=socket.gethostname())
    parser.add_argument("devices", nargs="+")

    args = parser.parse_args()

    with Path("output.csv").open("wt") as f:
        writer = csv.writer(f)
        writer.writerow([
            "name", "device", "role", "manufacturer", "serial", "asset_tag", "description",
        ])
        for dp in args.devices:
            ud = get_udev_dev(dp)
            wwn = ud.get("DM_WWN")
            mpaths = get_mapper_paths(dp)
            smartdev = get_smart_dev(mpaths[0])
            serial = smartdev.serial
            model = smartdev.model
            #print(f"{wwn},{serial},{model},{model_names.get(model, 'unnamed')},{model} {serial}")
            print(f"{model} {serial}: {dp}")
            writer.writerow([
                f"{model} {serial}",
                args.host,
                model_roles[model],
                model_mfgs[model],
                serial,
                wwn, # as asset tag
                model_names[model], # desc
            ])
