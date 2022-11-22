## ROS2 ISSUES

Used commands:

1. ros2 topic Command Line Tool

   - `ros2 topic list`

     ```python
     $ ros2 topic list
     /greetings
     /parameter_events		# also automatically started when you start the node. Every time a change has been made to parameters for this node, the change will be published to this topic.
     /rosout							# all nodes automatically have a publisher to this topic when started. When you print a ROS2 log, the log will be sent to that topic.
     ```

   - `ros2 topic echo /*` : Print the data going through a Topic

   - `ros2 topic info/type /*` : Get more details about a Topic

     ```python
     $ ros2 topic info /greetings 
     Type: example_interfaces/msg/String
     Publisher count: 1
     Subscription count: 0
     ```

   - `ros2 topic pub /*` : Publish to a topic from the terminal

   - `ros2 topic hz /*` : Check if your publishers/subscribers manage to follow the rhythm

   - `ros2 topic bw /*` : Check how much data is going through a Topic

     ```python
     $ ros2 topic bw /greetings 
     Subscribed to [/greetings]
     271 B/s from 5 messages
         Message size mean: 44 B min: 44 B max: 44 B
     243 B/s from 10 messages
         Message size mean: 44 B min: 44 B max: 44 B
     235 B/s from 15 messages
         Message size mean: 44 B min: 44 B max: 44 B
     ```

   - `ros2 node info /*` : Find topic info directly from a node’s name

     ```python
     $ ros2 node info /greetings_publisher 
     /greetings_publisher
       Subscribers:
       Publishers:
         /greetings: example_interfaces/msg/String
         /parameter_events: rcl_interfaces/msg/ParameterEvent
         /rosout: rcl_interfaces/msg/Log
       Service Servers:
       Service Clients:
       Action Servers:
       Action Clients:
     ```

2. Ubuntu

   - `pgrep -l test_mul...`
   - `pidstat -p #PID 1`



### I. Publishing is **slow** in MutliThreadedExecutor (Dec 8, 2020)

> Related Issues:
>
> - [Publishing is slow in Docker with MutliThreadedExecutor #1487](https://github.com/ros2/rclcpp/issues/1487)
>
>   <img src="/Users/liusongran/Library/Application Support/typora-user-images/image-20220716103813658.png" alt="image-20220716103813658" style="zoom:40%;" />
>
> - [MutliThreadedExecutor update rate is unstable #260](https://github.com/ros-controls/ros2_control/issues/260)
>
> - 