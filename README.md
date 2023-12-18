# ROS Driver for Motion Capture Systems
![VICON Logo](http://www.awn.com/sites/default/files/styles/inline_medium/public/image/featured/1025139-vicon-delivers-motion-capture-innovations-siggraph-2015.jpg?itok=vsH7Prwo)

![QUALISYS Logo](https://cdn-content.qualisys.com/2021/01/qualisys-logo-530x.png)


## Overview
This package contains ROS drivers for two different motion capture systems,**VICON** And **QUALISYS**.
**NOTE:** This fork focuses on the Qualisys ROS driver. Some alterations have been made to the Vicon package to ensure compatability with the mutual interface.

**Keywords:** ROS, motion capture, Qualisys

## License
For the VICON driver, we use the [offical SDK](http://www.vicon.com/products/software/datastream-sdk).

For the QUALISYS driver, we use the [Qualisys CPP SDK](https://github.com/qualisys/qualisys_cpp_sdk).

The rest of the source code is released under the [Apache 2.0 license](LICENSE), wherever not specified.

## Compiling
This is a catkin package. Make sure the package is on `ROS_PACKAGE_PATH` after cloning the package to your workspace. Drivers for different motion capture system can be independently compiled.

```
cd your_work_space
catkin_make
```

This will compile the drivers for `{sys}`

## Example Usage

Run a qualisys node

	roslaunch mocap_qualisys qualisys.launch  server_address:=*QTM server address*

Replace `*QTM server address*` with the IP address to your QTM server.

## Launch files

* **qualisys.launch:** Launch a qualisys interface node

     - **`server_address`** IP address of the server of the motion capture system to be connected. Default: `qtm-pc.local`.

     - **`server_base_port`** The port used for setting up the connection with the motion capture server. Default: `22222`.

     - **`frame_rate`** Desired frame rate. Will use native frame rate if set to `0`. Default: `0`.

     - **`max_accel`** Max acceleration in m/s. Used to calculate noise parameters. Default: `10`.

     - **`publish_tf`** Set to `true` to publish transforms between the tracked bodies and the origin of the motion capture frame. Default: `true`.

     - **`track_6_dofs`** Set to `true` to enable tracking bodies. Default: `true`.

     - **`track_labeled_markers`** Set to `true` to enable tracking the markers that have been labeled in QTM (i.e. the one that are parts of a body, an AIM, ...). Default: `false`.

     - **`track_unlabeled_markers`** Set to `true` to enable tracking the markers that have not been labeled in QTM. Default: `false`.

     - **`fixed_frame_id`** Frame ID for the motion capture system frame of reference (child frame ids are set to the name of the subject). Default: `mocap`

     - **`udp_port`** Port that the server will stream data to. `0` indicates random UPD port, `-1` random TCP port and positive values specifies a UDP port.  Default: `0`.

     - **`qtm_protocol_version`** Minor version of the QTM protocol to use. Default: `18`

## Nodes

### mocap_qualisys_node

Connects to your local QTM server, and publishes poses, odometry and transforms based on 6DOF data.

#### Published Topics

* **`/qualisys/{subject_name}/pose`** ([geometry_msgs/PoseStamped])

* **`/qualisys/{subject_name}/odom`** ([nav_msgs/Odometry])

* **`/qualisys/{subject_name}/velocity`** ([geometry_msgs/TwistStamped])

   __Note:__ Replace `{subject_name}` with the name you have given the 6DOF body in QTM.

* **`/qualisys/markers`** ([mocap_base/MarkerList])

#### Parameters

* **`server_address`** (string)

   IP address of the server of the motion capture system to be connected.

* **`server_base_port`** (`string`, default: `22222`)

   The port used for setting up the connection with the motion capture server.
   Should be left to the default value.

* **`frame_rate`** (`int`, default: `0`)

   The frame rate of the motion capture system.
   A value of 0 uses whatever framerate the motion capture server is transmiting at.
   If lower frame rates are requested the server will drop frames to get close to the requested rate.
   For example, if the server is capturing at 100 FPS and 80 FPS is requested, every other frame will be dropped resulting in 50 FPS.

* **`max_accel`** (`double`, default: `10.0`)

   The max possible acceleration which serves to construct the noise parameters.

* **`publish_tf`** (`bool`, default: `false`)

   If set to true, tf msgs for the subjects are published.

* **`track_6_dofs`** (`bool`, default: `true`)

   If set to `true`, enable tracking rigid-bodies (6DOFs).

* **`track_labeled_markers`** (`bool`, default: `false`)

   If set to `true`, enable tracking the markers that have been labeled in QTM (i.e. the one that are parts of a body, an AIM, ...).

* **`track_unlabeled_markers`** (`bool`, default: `false`)

   If set to `true`, enable tracking the markers that have not been labeled in QTM.

* **`fixed_frame_id`** (`string`, default: `mocap`)

   The fixed frame ID of the tf msgs for each subject. Note that the child frame id is automatically set to the name of the subject.

* **`udp_port`** (`int`, default: `0`)

   The UDP port that the server will send data to. If set to 0 a random valid port is used. If set to -1
TCP will be used instead of UDP.

* **`qtm_protocol_version`** (`int`, default: `18`)

   The minor version of the QTM protocol that should be used (the only valid major version is 1).
   Might have to be lowered for very old versions of QTM.
   Should not be set lower than 8 due to a bug in the protocol version 1.7 and prior causing the rotations to be incorrectly searialized.

* **`model_list`** (`vector<string>`, default: `[]`)

   A vector of subjects of interest. Leave the vector empty if all subjects are to be tracked.

## Custom msgs

* **mocap_base/Marker** : See [mocap_base/msg/Marker.msg](mocap_base/msg/Marker.msg)

* **mocap_base/MarkerList** : See [mocap_base/msg/MarkerList.msg](mocap_base/msg/MarkerList.msg)

## FAQ

1. Will the msgs be delayed if the driver is handling several subjects?
   Possibly. It's not recommended to for example, try to run the node for two dozen bodies on a raspberry pie.
   The multithreading in earlier versions were removed since it often caused more overhead than actual gain.

## Bugs & Feature Requests

Please report bugs and request features using the [Issue Tracker](https://github.com/KTH-SML/motion_capture_system/issues).

[geometry_msgs/PoseStamped]: http://docs.ros.org/api/geometry_msgs/html/msg/PoseStamped.html
[nav_msgs/Odometry]: http://docs.ros.org/api/nav_msgs/html/msg/Odometry.html
[geometry_msgs/TwistStamped]: http://docs.ros.org/api/geometry_msgs/html/msg/TwistStamped.html
