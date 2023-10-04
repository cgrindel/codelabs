# LoggingClient iOS Application

## Quickstart

### Start the backend server

In a Terminal window, run the following to start the backend server.

```sh
$ bazel run //backend
```

### Launch the iOS applicaiton in a simulator

Run the following to launch the iOS application in a simulator.

```sh
$ bazel run //ios/LoggingClient/App
```

### (Optional) Configure the GRPC connection

The default connection values should connect to the GRPC server launched via `bazel run //backend`.
If that does not work, try using the actual IP address for the machine.

#### Get the IP address for the MacOS host

Run the following to get the IP address for the MacOS host. You will need to enter this value in the
iOS application user interface.

```sh
$ ipconfig getifaddr en0
```

#### Edit the GRPC connection in the iOS application

Once the iOS application launches,

1. Under the `Connection` section, tap the `Edit` button to bring up the edit connection screen.
2. Update the `Host` to the IP address for the MacOS host.
3. Tap the `Save` button.

### Send a log message

Under the `Log Message` section, enter some text and tap the send button (i.e., paper airplane
image).

Switch to the Terminal window that is running the backend server. You should see the log message
that you just sent.
