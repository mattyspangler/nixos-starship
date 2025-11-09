# Cardiotop System Architecture

Cardiotop is designed as a modular, multi-layered system following the Unix philosophy. It consists of independent components that can be chained together to create a flexible and powerful data processing pipeline. The architecture is divided into three logical layers: the **Device Layer**, the **Activity Layer**, and the **Consumer Layer**.

```
+-------------------+      +--------------------+      +-------------------+
|   Device Layer    |      |   Activity Layer   |      |  Consumer Layer   |
| (cardiotop-device)| pipe | (cardiotop-activity)| pipe | (cardiotop-tui,   |
|                   +----->|                    +----->|  jq, conky, etc.) |
+-------------------+      +--------------------+      +-------------------+
```

## 1. Device Layer (`cardiotop-device`)

The Device Layer is the foundation of the system. Its sole responsibility is to connect to a single hardware device and produce a clean, steady stream of line-delimited JSON data.

-   **Component:** `cardiotop-device`
-   **Input:** A device profile (`~/.config/cardiotop/device-profiles/*.json`) specifying the device address and which stateless **Device Plugins** to use.
-   **Output:** A stream of simple JSON objects to `stdout`. Each object represents a single data point from the device.
-   **Key Principles:**
    -   **Standalone:** It can be used entirely on its own. Its output can be piped to `jq`, `awk`, or any other standard command-line tool.
    -   **Stateless (Core):** The core of `cardiotop-device` is stateless. It connects and streams data. State can be managed by the optional Device Plugins (e.g., for creating a TCX file).
    -   **Unaware:** It has no knowledge of any other devices or of the Activity Layer.

## 2. Activity Layer (`cardiotop-activity`)

The Activity Layer is the central orchestrator and aggregator. It consumes data from one or more Device Layer processes and synthesizes it into a unified picture of the user's activity.

-   **Component:** `cardiotop-activity`
-   **Input:** An activity profile (`~/.config/cardiotop/activity-profiles/*.json`).
-   **Process:**
    1.  Reads the activity profile to determine which device profiles to launch (it supports a `"*"` wildcard to launch all).
    2.  Launches and manages a `cardiotop-device` subprocess for each required device.
    3.  Reads the JSON streams from all subprocesses in a non-blocking way.
    4.  As it reads, it **tags** each data point with the name of its source stream (derived from the device profile filename).
    5.  It aggregates data points with the same timestamp into a single, nested JSON object.
    6.  This aggregated object is then processed through one or more stateful **Activity Plugins** (e.g., `calorie_counter`).
-   **Output:** A stream of rich, aggregated JSON objects to `stdout`.

## 3. Consumer Layer (Various)

The Consumer Layer is any tool that consumes the final, processed data stream from the Activity Layer.

-   **Components:** `cardiotop-tui`, `conky`, `i3status`, `jq`, or any custom script.
-   **Input:** A stream of aggregated JSON from `cardiotop-activity`.
-   **Purpose:** To display the data to the user, log it to a file, or trigger alerts. This layer is concerned with presentation, not calculation.

This layered design ensures a clean separation of concerns, making the system easy to understand, maintain, and extend.