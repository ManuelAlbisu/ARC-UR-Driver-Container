FROM osrf/ros:humble-desktop

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# install additional dependencies
RUN \
    apt-get update && \
    apt-get install -y git software-properties-common build-essential python3-colcon-common-extensions python3-vcstool

# Create workspace directory
RUN mkdir -p /home/workspace/ros2_ur_driver/src

# Clone relavant packages
RUN \
    /bin/bash -c "source /opt/ros/humble/setup.bash && \
    cd /home/workspace/ros2_ur_driver && \
    git clone -b humble https://github.com/UniversalRobots/Universal_Robots_ROS2_Driver.git src/Universal_Robots_ROS2_Driver && \
    vcs import src --skip-existing --input src/Universal_Robots_ROS2_Driver/Universal_Robots_ROS2_Driver.${ROS_DISTRO}.repos && \
    rosdep update && \
    rosdep install --ignore-src --from-paths src -y && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release"

# setup entrypoint
COPY ./ros_entrypoint.bash /
RUN chmod a+x /ros_entrypoint.bash

ENTRYPOINT ["/ros_entrypoint.bash"]

WORKDIR /home/workspace/ros2_ur_driver/

CMD ["bash"]

RUN echo "ROS2 Humble Docker environment has been setup."
