# Cardiotop Design

This document outlines the design of the `cardiotop` utility.

## Core Principles

*   **Decoupled Tools:** The application is split into a data provider (`cardiotop`) and a separate visualizer (`cardiotop-tui`). This allows other tools to easily consume the JSON data stream.
*   **Modularity:** The system is composed of independent modules for devices and data processors, allowing for easy extension.
*   **Profile-Driven:** The data pipeline is defined by simple, human-readable JSON profile files.
*   **Simplicity:** The code is written to be clear and maintainable.

## Architecture

The `cardiotop` ecosystem is a pipeline of tools:

`cardiotop-menu` -> `cardiotop-tui` -> `cardiotop`

### 1. The Core Pipeline

*   **`cardiotop` (Python)**: The **Data Provider**. A command-line tool that takes a `--profile` argument. It reads the profile, loads the specified device and processor modules, and pipes a stream of processed JSON data to standard output.

*   **`cardiotop-tui` (Python/Textual)**: The **Visualizer**. A dashboard that finds all enabled user profiles, spawns a `cardiotop` process for each one, and renders the resulting JSON streams in a terminal UI.

### 2. Profile Management

Profiles are JSON files that define a complete data pipeline.

*   **Storage:** User profiles are stored in `~/.config/cardiotop/profiles/`.
*   **Enabling/Disabling:**
    *   An **enabled** profile is a `.json` file (e.g., `my_polar.json`).
    *   A **disabled** profile is renamed with a `.disabled` extension (e.g., `my_polar.json.disabled`).
    *   The `cardiotop-tui` only looks for `.json` files.

### 3. The Management UI

A suite of interactive shell scripts provide a user interface for managing profiles.

*   **`cardiotop-menu`**: The **main entry point**. It provides a menu to:
    *   View all profiles.
    *   Toggle a profile's state (enable/disable).
    *   Launch the "Add Profile" and "Delete Profile" wizards.

*   **`cardiotop-add-profile`**: An interactive wizard to create a new profile. It handles scanning for devices, selecting a device model, and naming the new profile.

*   **`cardiotop-delete-profile`**: A wizard to select and delete any existing profile.

### 4. Internal Helper Scripts

Helper scripts are prefixed with an underscore (`_`) to indicate they are not intended to be run directly.

*   **`_cardiotop_scan`**: Scans for nearby BLE devices.
*   **`_cardiotop_list_supported_devices`**: Lists the human-friendly device names supported by the available device modules.
*   **`_cardiotop_find_module`**: Recommends a device module based on a scanned device's name.
*   **`_cardiotop_create_profile`**: Generates the new JSON profile file.
*   **`_cardiotop_common.sh`**: Contains shared variables to keep the other scripts DRY.
