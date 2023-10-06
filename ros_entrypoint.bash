#!/bin/bash

set -e

# Setup the ROS2 Humble environment
source "/opt/ros/humble/setup.bash"
source "/home/workspace/ros2_ur_driver/install/setup.bash"
exec "$@"
