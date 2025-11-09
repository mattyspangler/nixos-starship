# Cardiotop Plugin Architecture

Cardiotop uses a two-tiered plugin system to process biometric data. This design follows the Unix philosophy, where small, independent components are chained together to create a powerful pipeline.

The two types of plugins are **Device Plugins** and **Activity Plugins**.

## 1. Device Plugins

Device plugins operate directly on the data stream from a single hardware device. They are simple, stateless, and designed for one-in, one-out data transformation.

-   **Location:** `plugins/device/`
-   **Purpose:** To transform or export raw data from a single device.
-   **Characteristics:**
    -   **Stateless:** Each data point is processed independently. They do not remember information from previous data points.
    -   **Single-Stream:** They only receive data from the one device profile they are attached to.
    -   **Configuration:** They are configured in a `device-profiles/*.json` file.

### Example: `tcx_export.py`

The TCX Exporter is a device plugin. It receives data points (timestamp, heart\_rate, etc.) and appends them to a list. When the `cardiotop-device` process exits, it writes the accumulated list to a TCX file.

### Configuration

Device plugins are configured within a device profile.

**File:** `~/.config/cardiotop/device-profiles/my_polar.json`
```json
{
  "device_name": "Polar Verity Sense",
  "device_address": "XX:XX:XX:XX:XX:XX",
  "plugins": [
    {
      "name": "tcx_export",
      "args": ["my_run.tcx"]
    }
  ]
}
```
In this example, every data point from the Polar sensor is passed to the `tcx_export.py` plugin.

## 2. Activity Plugins

Activity plugins are the core of data analysis in Cardiotop. They receive a *merged* stream of data from multiple devices and are designed for stateful, complex calculations.

-   **Location:** `plugins/activity/`
-   **Purpose:** To aggregate data from multiple sources and perform stateful analysis (e.g., calculating total calories, tracking distance).
-   **Characteristics:**
    -   **Stateful:** They have a `__init__` method and can use instance variables (`self.total_calories`) to track state across multiple data points.
    -   **Multi-Stream:** They receive a structured JSON object containing data from all active devices, timestamped and organized by device profile name.
    -   **Configurable:** They receive a `config` dictionary upon initialization, allowing for user-specific settings.

### Example: `calorie_counter.py`

The Calorie Counter is an activity plugin. It requires user-specific data (`age`, `weight_kg`, `assigned_sex`) to perform its calculations. It maintains `self.total_calories` to keep a running total.

### Data Structure

Activity plugins receive a JSON object like this:

```json
{
  "timestamp": 1678886400,
  "devices": {
    "polar_arm": {
      "heart_rate": 75,
      "rr": [800, 810]
    },
    "gps_puck": {
      "lat": 45.123,
      "lon": -93.456
    }
  },
  "activity": {}
}
```
The plugin reads from the `devices` dictionary and writes its results into the `activity` dictionary.

### Configuration

Activity plugins are configured within an activity profile.

**File:** `~/.config/cardiotop/activity-profiles/default.json`
```json
{
  "device_profiles": ["*"],
  "plugins": [
    {
      "name": "calorie_counter",
      "config": {
        "age": 35,
        "weight_kg": 70,
        "assigned_sex": "female"
      }
    }
  ]
}
```
In this example, the `calorie_counter` plugin is initialized with the user's specific biometric data. The `device_profiles: ["*"]` line tells `cardiotop-activity` to listen to all available device profiles.