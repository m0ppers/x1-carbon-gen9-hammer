# x1-carbon-gen9-hammer

Script to more or less fix the throttling problems of an x1 carbon gen9

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