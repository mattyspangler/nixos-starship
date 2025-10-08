# Signal Registration Instructions

These instructions will guide you through registering your phone number with the `signal-cli-rest-api` container.

## Prerequisites

*   The `signal-cli` systemd service must be running. You can check its status with the command `systemctl --user status signal-cli`.

## Registration Steps

1.  **Request a verification code.** Open a terminal and run the registration script with your phone number as an argument. Be sure to include the country code.

    ```bash
    ./signal-register.sh <phone_number>
    ```

    For example:

    ```bash
    ./signal-register.sh +15551234567
    ```

2.  **Wait for the SMS.** You should receive an SMS with a 6-digit verification code.

3.  **Verify the code.** Once you have the code, run the verification script with your phone number and the code as arguments.

    ```bash
    ./signal-verify.sh <phone_number> <code>
    ```

    For example:

    ```bash
    ./signal-verify.sh +15551234567 123456
    ```

4.  **Registration complete.** Your number should now be registered with `signal-cli`. You can now use the `signal-cli-rest-api` to send and receive messages.

## Troubleshooting

*   If you don't receive an SMS, you can try requesting a voice call instead. To do this, edit the `signal-register.sh` script and change `\"use_voice\": false` to `\"use_voice\": true`.
*   If you encounter any other issues, you can check the logs of the `signal-cli` service with the command `journalctl --user -u signal-cli`.