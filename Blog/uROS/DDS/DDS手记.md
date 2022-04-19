[TOC]

# 一、DDS标准介绍

## A. DDS介绍

OMG DDS (Data Distribution Service) 是一个中间件协议和API标准，它提供低延迟、高可靠的以数据为中心的连接，对系统组件进行集成，为业务和关键任务物联网 (IoT)应用程序提供所需的可扩展架构。

在分布式系统中，中间件是位于操作系统和应用程序之间的软件层。它使系统的各个组件能够更轻松地通信和共享数据。它通过屏蔽应用程序和系统之间传递信息的机制，让软件开发人员专注于应用程序设计，从而简化分布式系统软件开发。

<img src="https://udds-portal-public.oss-cn-hangzhou.aliyuncs.com/dds-standard.png" alt="DDS中间件系统结构图" style="zoom:50%;" />

DDS 中间件是一个软件层，它将应用程序从操作系统、网络传输和底层数据格式的细节中抽象出来。DDS中间件为不同的编程语言提供相同的概念和API，允许应用程序跨操作系统、编程语言和处理器架构交换信息。

 数据格式、应用程序的互相发现、数据连接、可靠性、协议、传输方式选择、QoS、安全性等底层细节由中间件管理。

DDS是一个以数据为中心的开放式国际互联标准，是一个经过验证的工业物联网数据连接标准。DDS标准主要有以下优点：

- 高性能、可扩展、安全且以数据为中心的发布/订阅抽象模型；
- 具有动态发现服务的完全去中心化架构，可自动在匹配节点之间建立通信；
- 丰富的服务质量 (QoS) 特性，用于控制数据分发的各个方面，例如数据可用性、资源使用情况、可靠性和时延控制；
- 可互操作的数据共享，独立于平台的可扩展数据建模、编码和表示；
- 最新扩展支持RPC、安全、资源受限设备、Web 集成和 OPC UA 集成。

### 1. 以数据为中心

<img src="https://udds-portal-public.oss-cn-hangzhou.aliyuncs.com/dds-cloud.png" alt="DDS中间件组成元素逻辑关系图" style="zoom:50%;" />

DDS 提供基于QoS控制的数据共享。应用程序通过发布和订阅由其主题名称标识的主题进行通信。应用程序订阅时可以指定时间和内容过滤器，以获取在该主题上发布的数据的子集。不同的DDS数据域彼此完全独立，DDS数据域之间无法完成数据共享。

现实中有许多通信中间件的标准和产品，DDS以数据为中心的特性使其非常适合工业物联网。大多数中间件通过在应用程序和系统之间发送信息来工作。以数据为中心的特性确保所有通过DDS发送的消息都包含应用程序能够完全理解其接收数据所需的上下文信息。

**以数据为中心的本质是 DDS 知道它存储了什么数据并控制如何共享这些数据**。使用传统的以消息为中心的中间件的程序员必须编写发送消息的代码。使用以数据为中心的中间件的程序员编写代码仅需指定如何以及何时共享数据。DDS 不是在应用程序代码中管理所有这些复杂性，而是**直接为应用程序实现受控、托管、安全的数据共享**。

### 2. 全局数据空间

从概念上讲，DDS将本地数据存储区称为“全局数据空间”。对应用程序来说，全局数据空间就像通过API访问的本地内存。应用程序发送数据看起来像写入本地存储。实际上，DDS会发送消息来更新远程节点上的存储。远程节点上的接收方程序看起来像从本地存储取得数据。

在 DDS域内，信息共享单元是主题内的数据对象。主题由其名称标识，数据对象由一些“键值”属性标识，类似于使用关键属性来标识数据库中的记录。DDS应用程序之间为点对点通信，不需要通过服务器或云来转发数据。

总的来说，本地存储给应用程序一种可以访问整个全局数据空间的错觉。这只是一种错觉，没有一个公共的地方可以存放所有数据。每个应用程序只在本地存储它需要的内容，并且只在它需要的时间窗口内存储。**全局数据空间是一个虚拟概念**，实际上只是本地存储的集合。使用任意语言开发并在任意系统上运行的应用程序，都以最恰当的方式访问本地内存。 全局数据空间使得应用程序可以跨多种传输方式在嵌入式、移动和云之间共享数据并且具有极低的延迟。

### 3. 服务质量

数据可以通过灵活的服务质量 (QoS) 规范实现共享，包括可靠性、系统健康程度（活跃度）以及安全性。真实系统中并非所有其他应用程序都需要本地存储中的每条数据。DDS可以智能地发送其他应用程序需要的数据。如果数据无法100%到达其预定接收方，DDS中间件提供可靠性QoS解决这一问题。

当系统发生变化时，DDS中间件动态地确定将哪些数据发送到哪里，并将变化通知参与者。如果总数据量很大，DDS会自动过滤数据并且只发送每个应用程序真正需要的数据。当需要快速更新数据时，DDS会发送多播消息，在发送一次数据情况下，远程应用程序都能接收到数据。随着数据格式的发展，DDS中间件会获取系统各个应用程序使用的DDS版本并自动进行数据转换。对于安全关键型应用程序，DDS中间件提供控制访问、强制执行指定数据流路径传输以及即时加密数据等功能确保其安全性。

在一个非常动态、苛刻和不可预测的环境中，当应用程序同时使用这些QoS时，DDS 的强大功能便体现出来，并且以极快的速度完成高效可靠的数据传输。

### 4. 动态发现

DDS 提供发布者和订阅者的动态发现。动态发现使DDS 应用程序可扩展。意味着应用程序不必知道或配置用于通信的端点，因为它们会被 DDS 自动发现。这可以在程序运行时完成，而不必在设计或编译时完成。这一特点为 DDS 应用程序实现真正的“即插即用”。

DDS的动态发现比应用程序的发现更进一步，DDS会发现应用程序是在发布数据、订阅数据还是既发布也订阅数据，同时DDS也将发现应用程序正在发布或订阅的数据类型。它还将发现发布者提供的通信特性和订阅者请求的通信特性。在DDS参与者的动态发现和匹配过程中，所有这些属性都会被考虑在内。

DDS参与者可以在同一台机器上也可以通过网络连接。应用程序使用相同的DDS API 进行通信。由于无需了解或配置 IP 地址，也无需考虑机器架构的差异，因此在任何操作系统或硬件平台上添加额外的通信参与者都变得非常简单。

### 5. 安全性

DDS 包括为信息分发提供身份验证、访问控制、机密性和完整性的安全机制。DDS Security 使用分散的对等架构，可在不牺牲实时性能的情况下提供安全性。

## B. DDS标准规范

OMG DDS标准主要包括以下规范：

### 1. 核心规范

-  **[DDS v1.4](https://www.omg.org/spec/DDS/1.4/PDF)**：DDS 规范描述了**以数据为中心的发布-订阅 (DCPS) 模型**，该模型用于分布式应用程序通信和集成。
- **[DDSI-RTPS v2.3](https://www.omg.org/spec/DDSI-RTPS/2.3/PDF)**：RTPS规范定义了**实时发布-订阅协议 (RTPS)**，此协议为DDS标准中互操作有线协议。
- **[DDS-XTypes v1.3](https://www.omg.org/spec/DDS-XTypes/1.3/PDF)**：此规范定义DDS**数据类型系统**以及DDS数据的**序列化表示方法**。
- **[DDS-Security v1.1](https://www.omg.org/spec/DDS-SECURITY/1.1/PDF)**：此规范为DDS实现定义了**安全模型**和服务插件接口 (SPI) 架构。

### 2. 类型语法和语言映射(IDL)规范

- [**IDL4 v4.2**](https://www.omg.org/spec/IDL/4.2/PDF)（即ISO标准ISO/IEC 19516:2020）：接口定义语言（Interface Definition Language）规范定义了IDL，一种用于以独立于编程语言的方式定义数据类型和接口的语言。IDL规范不是 DDS 标准，但 DDS 依赖于它。
- [**IDL4-JAVA**](https://www.omg.org/spec/IDL4-Java/1.0/Beta2/PDF)：此规范定义了 IDL4 类型到 Java 语言的映射。
- [**IDL4-C#**](https://www.omg.org/spec/IDL4-CSHARP/1.1/Beta1/PDF)：此规范定义了 IDL4 类型到 C# 语言的映射。

### 3. 应用程序接口（API）规范

- [**DDS C++ API****（对应ISO/IEC C++ 2003）**](https://www.omg.org/spec/DDS-PSM-Cxx/1.0/PDF)：此规范为DDS规范中以数据为中心的发布-订阅 (DCPS) 部分定义了C++ API。
- [**DDS Java API****（对应Java 5）**](https://www.omg.org/spec/DDS-Java/1.0/PDF)：此规范为DDS规范中以数据为中心的发布-订阅 (DCPS) 部分定义了Java API。

### 4. 扩展规范

- [**DDS-RPC v1.0**](https://www.omg.org/spec/DDS-RPC/1.0/PDF)：此规范定义了一个分布式服务框架，该框架提供了独立于语言的服务定义以及使用DDS进行通信的服务/远程过程调用。此规范支持自动发现，同步和异步调用并可使用多种QoS。
- **[DDS-XML v1.0](https://www.omg.org/spec/DDS-XML/1.0/PDF)**：此规范定义了用于表示DDS相关资源的XML语法，为DDS服务质量 (QoS)、DDS 数据类型和DDS 实体（DomainParticipants、Topics、Publishers、Subscriber、DataWriters和DataReaders）提供XSD模式文件。
- **[DDS-JSON v1.0](https://www.omg.org/spec/DDS-JSON/1.0/PDF)**：此规范定义了用于表示 DDS 相关资源的JSON语法，为 DDS 服务质量 (QoS)、DDS数据类型、DDS数据和 DDS 实体（DomainParticipants、Topics、Publishers、Subscriber、DataWriters和DataReaders）提供JSON模式文件。

### 5. 网关规范

- [**DDS-WEB v1.0**](https://www.omg.org/spec/DDS-WEB/1.0/PDF)：此规范定义了一个独立于平台的抽象交互模型，用于说明Web客户端应该如何访问DDS系统以及一组DDS到特定 Web 平台的映射，这些特定 Web 平台在标准Web技术和协议方面实现了平台无关模型 (PIM)。
- [**DDS-OPCUA v1.0**](https://www.omg.org/spec/DDS-OPCUA/1.0/PDF)：此规范定义了一个标准的、可配置的网关，它支持使用DDS的系统和使用OPCUA的系统之间的互操作和信息交换。
- **[ DDS-XRCE v1.0](https://www.omg.org/spec/DDS-XRCE/1.0/PDF)**：此规范定义了资源受限的低功耗设备向DDS域发布和订阅数据的协议。XRCE协议将XRCE客户端（Client）与DDS 代理（Agent）连接，该DDS代理充当连接至DDS域的网关。

### 6. 正在进行研究的规范（未发布）

- **DDS-TSN**：此规范定义了一组机制，这些机制可以将DDS部署到时间敏感网络 (TSN) 上，并利用TSN特性实现特定功能。此规范定义了DDSI-RTPS 协议到 TSN 传输方式的映射。
- **DDSI-RTPS TCP/IP PSM**：此规范定义了DDSI-RTPS 协议到TCP/IP传输方式的映射。
- **DDS C# API**：此规范为DDS规范中以数据为中心的发布-订阅 (DCPS) 部分定义了C# API。

## C. 核心规范介绍

### 1. DDS

DDS规范描述了**以数据为中心**的**发布-订阅(DCPS)**模型，该模型用于分布式应用程序通信和集成。该规范定义了应用程序接口 (API) 和通信语义（行为和服务质量QoS），它们能够有效地将信息从信息生产者传递到匹配的信息消费者。DDS规范的目的可以概括为：**在正确的时间将正确的信息高效、可靠地传送到正确的地点**。

DDS规范总共有四个正式版本，如下表所示：

- 2015.03: [V1.4](https://www.omg.org/spec/DDS/1.4/)
- 2006.12: [V1.2](https://www.omg.org/spec/DDS/1.2/)
- 2005.12: [V1.1](https://www.omg.org/spec/DDS/1.1/)
- 2004.12: [V1.0](https://www.omg.org/spec/DDS/1.0/)

### 2. RTPS

RTPS规范定义了DDS的互操作有线协议。它的目的和范围是为了确保基于不同供应商DDS实现的应用程序可以互操作。

RTPS规范总共有四个正式版本，如下表所示：

- 2019.05: [V2.3](https://www.omg.org/spec/DDSI-RTPS/2.3/)
- 2014.09: [V2.2](https://www.omg.org/spec/DDSI-RTPS/2.2/)
- 2010.11: [V2.1](https://www.omg.org/spec/DDSI-RTPS/2.1/)
- 2008.04: [V2.0](https://www.omg.org/spec/DDSI-RTPS/2.0/)

### 3. DDS-XTYPES

 DDS-XTYPES规范定义了可用于DDS主题的数据类型模型。数据类型系统是使用 UML 正式定义的。该数据类型系统在规范的7.2节及其子条款中定义。

DDS-XTYPES规范总共有四个正式版本。

### 4. DDS-SECURITY

DDS-SECURITY规范定义了符合 DDS 实现的安全模型和服务插件接口 (SPI) 架构。DDS 安全模型通过 DDS 实现调用这些SPI来强制执行。本规范还定义了一组这些SPI的内置实现。

DDS-SECURITY规范总共有两个正式版本。

## D. 扩展阅读

1. [万物互联时代，DDS将助力您的行业前行](https://www.platforu.com/DetailsPage?id=18)
2. [一文读懂XMPP、DDS、MQTT、AMQP、REST、HTTP协议的区别](https://www.platforu.com/DetailsPage?id=19)
3. [DDS和TSN：实时数据交换的未来？](https://www.platforu.com/DetailsPage?id=29)
4. [DDS and TSN: The Future for Real-Time Data Exchange?](https://www.rti.com/blog/dds-and-tsn-the-future-for-real-time-data-exchange)

# 二、Fast DDS ([Fast RTPS](https://fast-dds.docs.eprosima.com/en/latest/fastdds/getting_started/getting_started.html))

## A. DDS介绍

### 1. The DCPS conceptual model

![../../_images/dds_domain.svg](https://fast-dds.docs.eprosima.com/en/latest/_images/dds_domain.svg)

- **Publisher**
- **Subscriber**
- **Topic**
- **Domain**

### 2. What is RTPS?

The [Real-Time Publish Subscribe (RTPS)](https://www.omg.org/spec/DDSI-RTPS/2.2/PDF) protocol, developed to support DDS applications, is a publication-subscription communication middleware over best-effort transports such as UDP/IP. Furthermore, Fast DDS provides support for TCP and Shared Memory (SHM) transports.

![../../_images/rtps_domain.svg](https://fast-dds.docs.eprosima.com/en/latest/_images/rtps_domain.svg)

## B. Library Overview

### 1. Architecture

The architecture of *Fast DDS* is shown in the figure below, where a layer model with the following different environments can be seen.

- **Application layer**. The user application that makes use of the *Fast DDS* API for the implementation of communications in distributed systems.
- **Fast DDS layer**. Robust implementation of the DDS communications middleware. It allows the deployment of one or more DDS domains in which DomainParticipants within the same domain exchange messages by publishing/subscribing under a domain topic.
- **RTPS layer**. Implementation of the [Real-Time Publish-Subscribe (RTPS) protocol](https://www.omg.org/spec/DDSI-RTPS/2.2) for interoperability with DDS applications. This layer acts an abstraction layer of the transport layer.
- **Transport Layer**. *Fast DDS* can be used over various transport protocols such as unreliable transport protocols (UDP), reliable transport protocols (TCP), or shared memory transport protocols (SHM).

<img src="https://fast-dds.docs.eprosima.com/en/latest/_images/library_overview.svg" alt="../../_images/library_overview.svg" style="zoom:50%;" />

### 2. Programming and execution model

1. **Concurrency and multithreading**

   *Fast DDS* implements a concurrent multithreading system. Each DomainParticipant spawns a set of threads to take care of **background tasks** such as logging, message reception, and asynchronous communication. This should not impact the way you use the library, i.e. the *Fast DDS* API is thread safe, so you can fearlessly call any methods on the same DomainParticipant from different threads. However, this multithreading implementation must be taken into account when external functions access to resources that are modified by threads running internally in the library. An example of this is the modified resources in the entity listener callbacks. The following is a brief overview of how *Fast DDS* multithreading schedule work:

   - **Main thread**: Managed by the application.
   - **Event thread**: Each DomainParticipant owns one of these. It processes periodic and triggered time events.
   - **Asynchronous writer thread**: This thread manages asynchronous writes for all DomainParticipants. Even for synchronous writers, some forms of communication must be initiated in the background.
   - **Reception threads**: DomainParticipants spawn a thread for each reception channel, where the concept of a channel depends on the transport layer (e.g. a UDP port).

2. **Event-driven architecture**

   There is a time-event system that enables *Fast DDS* to respond to certain conditions, as well as schedule periodic operations. Few of them are visible to the user since most are related to DDS and RTPS metadata. However, the user can define in their application periodic time-events by inheriting from the `TimedEvent` class.

   









