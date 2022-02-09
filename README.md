# x1-carbon-gen9-hammer

Script to more or less fix the throttling problems of an x1 carbon gen9

## Background

The X1 Carbon Gen 9 firmware severly throttles down to CPU frequencies that make my (and yours as well?) X1 barely useable.
This script wildly hammers the wattage that the laptop is allowed to use.

Based on the findings here: https://github.com/erpalma/throttled/issues/255#issuecomment-910135681

## Installation

Adjust the path in `x1-carbon-gen9-hammer.service` and copy it to /etc/systemd/system

```
sudo systemctl daemon-reload
sudo systemctl enable x1-carbon-gen9-hammer
sudo systemctl start x1-carbon-gen9-hammer
```

## Caveats

Switching power profiles when under heavy load may force thermal shutdown.
Be warned. No guarantees.