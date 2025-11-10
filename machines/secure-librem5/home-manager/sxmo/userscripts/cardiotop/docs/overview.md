# Cardiotop Design

This document outlines the design of the `cardiotop` ecosystem.

## Core Principles

*   **Unix Philosophy:** The system is composed of small, independent tools that do one thing well and communicate via pipes.
*   **Decoupled:** Data producers are separate from data consumers, allowing for flexible composition.
*   **Profile-Driven:** All configuration is done via simple JSON files.
*   **Extensible:** Functionality is added via self-contained, chainable plugins.

## Architecture

The ecosystem is a suite of composable tools that communicate via piped, line-delimited JSON. It is composed of **Core Applications**, **Plugins**, and **Consumer Applications**.

### 1. Core Applications

*   **`cardiotop-device`**: The foundation of the system. It connects to a single hardware device (based on a **Device Profile**) and runs a chain of **Device Plugins** on the raw data stream. It outputs a processed JSON stream to `stdout`.
*   **`cardiotop-activity`**: The multi-device aggregator. It reads an **Activity Profile** to launch multiple `cardiotop-device` instances. It merges their data streams and then runs the combined stream through a chain of **Activity Plugins**. It outputs a final, enriched JSON stream to `stdout`.

### 2. Plugins

Plugins are chainable scripts that read JSON from `stdin` and write JSON to `stdout`. They are dynamically loaded by the Core Applications.

*   **Device Plugins (`plugins/device/`)**: Simple, stateless transformers for single-device data.
*   **Activity Plugins (`plugins/activity/`)**: Stateful plugins that can process the combined data from multiple devices (e.g., `calorie_counter`).

### 3. Consumer Applications

These are standalone, top-level applications that consume a JSON stream from `stdin`. They are the endpoints of a `cardiotop` pipeline.

*   **`cardiotop`**: A lightweight, terminal-based dashboard for real-time visualization. It is a simple shell script that uses `jq` to format the data stream into a human-readable display.
*   **Other Consumers**: Any script or program that can read line-delimited JSON from `stdin` (e.g., `i3status`, `conky`).

### 4. Configuration (Profiles)

*   **Device Profiles** (`~/.config/cardiotop/device-profiles/`): Define a single piece of hardware, its driver, and a chain of **Device Plugins** to run. The `processors` key should contain a simple list of plugin names.
*   **Activity Profiles** (`~/.config/cardiotop/activity-profiles/`): Define a workout session.
    *   `device_profiles`: A list of device profiles to use as inputs. A `"*"` wildcard can be used here to include all available device profiles.
    *   `activity_plugins`: A list of activity plugins to run on the combined stream. Each plugin is an object with a `name` and a `config` block for plugin-specific settings. **A wildcard is not supported here.**

### 5. Management Scripts

A suite of shell scripts provide a UI for managing device profiles.

*   **`sxmo_cardiotop.sh`**: Main SXMO menu entry point for managing profiles and launching the `cardiotop` dashboard.
*   **`cardiotop-add-profile`**: Wizard to create a new **Device Profile**.
*   **`cardiotop-delete-profile`**: Wizard to delete a **Device Profile**.

## Example Pipeline

A typical pipeline for real-time monitoring looks like this:

```sh
cardiotop-activity "My Activity" | cardiotop
```

1.  `cardiotop-activity "My Activity"` reads the "My Activity" profile, launches the required device streams, processes the data through activity plugins, and pipes the final JSON to `stdout`.
2.  `cardiotop` reads the JSON from `stdin` and renders the formatted dashboard in the terminal.
