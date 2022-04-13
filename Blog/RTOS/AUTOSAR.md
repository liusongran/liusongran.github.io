[TOC]

# 汽车ECU操作系统标准OSEK/VDX及AUTOSAR标准

在这个强大的市场需求和激烈竞争的环境下，汽车电子的软硬件产品不断发展并出现多元化格局。 这时一些问题凸显出来，比如，由于处理器( CPU)不断升级导致不同的CPU间的软件移植滞后，由于不同实时操作系统的应用程序接口(API)不同，导致应用程序的移植性差等。

为了改变这些状况，汽车行业借鉴通信行业的做法，把汽车嵌入式系统、部件间通信、部件管理逐步规范化、标准化。从而出现了车规级操作系统及标准。当前主要的汽车行业操作系统有：

- ECU/TCU等底层控制单元：基于AUTOSAR OSEK/VDX的rtos
- 仪表等需要简单界面的人机交互单元：QNX，AGL
- 导航中控等强人机交互单元：Windows CE、Android

当然，还有其他一些大厂自行开发的操作系统，而且上述的各类系统也是在相互渗透的，比如早期的导航不少也是用的QNX。本文只讲述OSEK/VDX标准的实时操作系统。

<img src="https://upload-images.jianshu.io/upload_images/7412056-a801f487633c5340?imageMogr2/auto-orient/strip|imageView2/2/w/649/format/webp" alt="img" style="zoom:80%;" />

## A. OSEK/VDX标准

1993年德国汽车工业界提出了OSEK(德文:Offene Systeme and deren Schnittstellen fur dieElektronik im Kraftfahr-zeug)体系，其含义是汽车电子开放式系统及其接口。这个体系的最早倡导者有：宝马、博世、戴姆勒克莱斯勒、欧宝、西门子、大众和卡尔斯鲁厄大学的工业信息技术研究所。法国的汽车制造商标致和雷诺于1994年加人了OSEK体系，并将法国汽车工业使用的汽车分布式运行系统(Vehicle Distributed eX-ecutivr, VDX)也纳入这一体系，VDX的作用与OSEK相似。

在1995年召开的研讨会上，众多的厂商对OSEK和VDX的认识达成了共识，产生了OSEK/VDX规范（1997年发布）。它主要由四部分组成：操作系统规范（OSEK Operating System，**OSEK OS**）、通信规范（OSEK Communication，**OSEK COM**）、网络管理规范（OSEK Net Management，**OSEK NM**）和OSEK实现语言（OSEK Implementation Language，**OIL**）。

OSEKWorks，ETAS公司的RTA-OSEK，MOTOROLA的OSEKturbo和美国密西根大学的EMERALDS-OSEK等。随着该规范应用的不断深人，其结构和功能不断完善和优化，版本也不断升级和扩展。

<img src="https://upload-images.jianshu.io/upload_images/7412056-099647b1407a54f5?imageMogr2/auto-orient/strip|imageView2/2/w/449/format/webp" alt="img" style="zoom:80%;" />

## B. OSEK/VDX操作系统的特点

### 1. 实时性

由于越来越多的微处理器被应用到汽车控制领域，如汽车刹车的防抱死系统、动力设备的安全控制等这些系统直接关系着人的生命安全，即使出现丝毫的差错也会导致危及生命安全的严重后果，因此要求操作系统具有严格的实时性。OSEK操作系统通过静态的系统配置、抢占式调度策略、提供警报机制和优化系统运行机制以提高中断响应速度等手段来满足用户的实时需求。

### 2. 可移植性

OSEK规范详细规定了操作系统运行的各种机制，并在这些机制基础上制定了标准的应用程序编程接口，使那些独立编写的代码能够很容易地整合起来，增强了应用程序的可移植性。OSEK还制定了标准的OIL，用户只需更改OIL配置文件中与硬件相关部分，便可实现不同微处理器之间的应用程序移植。通过这些手段，减少了用于维护应用程序软件和提高它的可移植性的花费，降低了应用程序的开发成本。

### 3. 可扩展性

为了适用于广泛的目标处理器，支持运行在广泛硬件基础上的实时程序，OSEK操作系统具备高度模块化和可灵活配置的特性。它定义了不同的符合级别( Conformance Classes)，并采用对不同应用程序有可靠接收能力的体系结构，从而增强了系统的可扩展性。OSEK操作系统可以在很少的硬件资源(RAM,ROM,CPC时间)环境下运行，即便在8位微处理器上也是如此。

## C. OSEK/VDX操作系统的运行机制

### 1. 进程（TASK）管理和调度

在OSEK操作系统中，进程管理能力相对有限，这是因为系统的进程设置在系统生成时已经定义好了，并目，系统中进程的数量保持不变，不允许动态创建和删除进程。OSEK规范把进程分为基础进程和扩展进程。基础进程状态包括：就绪态、运行态和挂起态，进程切换只发生在这三种状态之间；扩展进程除了具有基础进程的三种状态外，还有等待态，并支持事件机制。

基础进程通常在开始运行后，只有当它被高优先级进程占先或者是被中断时，它才会停止，否则一直运行到进程结束。而扩展进程除了能被高优先级的进程占先和被中断外，还会因等待事件而停止运行，进人等待态。处于等待态的扩展进程只有当它所等待的事件中至少有一个发生才会被激活继续运行。

处于就绪态的进程由调度程序调度运行，OSEK规范采用静态优先级调度策略。进程的优先级在系统生成的时候进行静态分配，高优先级的进程先处理，低优先级的进程后处理，具有相同优先级的进程则进入一个先来先服务的队列。此外进程可分为可被占先进程和不可被占先进程：对不可被占先的进程而言，一旦进程开始运行，就不会被占先，只有到达其调度点时才发生调度，程序设计员可以预知调度点；而对可被占先的进程而言，由于中断可能激活更高优先级的进程，所以任何时候都有可能进行调度，使用这两种进程可使程序设计具有更高的灵活性。

OSEK操作系统不允许同一进程的多个并行调用，因为这需要动态改变进程的数量。当请求调用一个已经激活的进程时，该请求进人一个请求队列，直到前一个激活进程运行终止(转换为挂起态)，第二个激活请求才执行。

### 2. 进程间通信及同步机制

OSEK提供了两种同步机制，即对共享资源的互斥访问机制和事件机制。

OSEK的资源可以是一段临界区代码、调度程序、共享内存或数据结构，也可以是共享硬件设备。系统在处理多个进程对共享资源的互斥访问时，采用信号量对临界区数据或资源加锁。在某一时刻只能有一个进程访问资源，但是用信号量机制可能会导致优先级反转，即当一个高优先级的进程试图访问一个已经被较低优先级的进程占用的资源时，则该高优先级的进程必须等待，直到低优先级的进程释放该资源。这时如果有大量的介于前两个进程优先级之间的进程被激活，而且它们根本不使用该资源，那么，占据资源的低优先级进程就会被占先，等待资源的高优先级进程也不能执行，而中间优先级的进程要先于高优先级的进程运行，这就是优先级反转。为了避免这种情况发生，OSEK操作系统采用了优先级最高限度协议（Priority Ceiling Protocol ），即当一个进程占用了一个资源后，该进程的优先级会临时升高为该资源优先级。其优先级为可能使用该资源的所有进程优先级的最高值。这样，该进程只会被不使用该资源并且比该资源的优先级高的进程占先，直到它释放该资源为止。因此，当一个进程试图占用一个资源的时候，不可能有任何其他进程正占用着该资源，也就不会有因试图占用资源而进人等待态的进程。使用该协议同时解决了死锁的问题，当两个进程都已占用了一个资源，而且又试图访问对方所占有的资源时，它们无限期地相互等待下去就会发生死锁。该协议中不存在等待进程，自然也就避免了死锁。

此外，OSEK还提供了另一种同步机制，即事件机制。该机制的含义是，一个处于等待状态的扩展进程，只有当它所等待的事件至少有一个发生，才能进入就绪态，并且事件的发生会以信号的方式传给该进程。事件机制既可用于多个进程的同步，同时也是进程内部通信的方法之一。虽然只有扩展进程才可以等待事件，但设置这些事件的却可以是任何进程或中断服务程序。有一点要注意，为了遵循占用子资源就不被阻断的原则，必须避免一个占用了资源的进程因等待事件而进人等待状态。

### 3. 告警机制

汽车电子控制最典型的特性就是实时性，因此系统必须有基于时间或其他计数器的处理机制，来处理定时和循环进程。为此，OSEK提供了警报机制。警报或者基于系统时钟，或者基于其他的某种计数器，当计数器到达警报设定值时被触发。警报触发后可以激活进程也可以为某一进程设置事件，或者干脆执行一个警报回调程序，具体怎样由用户在系统生成时静态定义，但警报值是动态设置的，可以是相对值或者是绝对值，也可以设为循环警报来激活周期性进程。

### 4. 中断

汽车控制系统要求对实时输人作出快速反应。在OSEK操作系统中，由应用程序开发者编写的中断服务程序（ISR）与系统封装在一起，这样有利于保护进程和系统状态。OSEK操作系统把**中断处理程序分为两类**：(1) 中断服务程序不会调用系统服务；(2) 中断服务程序可以调用部分系统功能，如激活进程、设置事件、设置警报等，因此，它可以激活更高优先级的进程。OSEK操作系统的中断管理提供了开/关全部中断和开/关全部第三类中断的系统调用。**OSEK操作系统内核是一个可重入内核**，因此，**那些正在执行内核代码的进程（如正在执行系统调用）可能被中断，交出CPU的使用权**，必要时都不允许等到内核代码运行完，这有利于缩短由中断启动的更高优先级进程的平均延时。OSEK操作系统还支持中断的嵌套。

### 5. 符合级别

由于汽车嵌入式领域的应用范围很广，所以不同的应用程序软件可能对操作系统的要求有所不同，而且系统实现的硬件环境也存在很大的差异(如在处理器类型、存储容量等方面的不同)，这就要求操作系统具有灵活的配置能力。

OSEK规范把这些配置上的不同特点组织成四个级别，即四个符合级别:BCC1,BCC2,ECC1和ECC2。各符合级别在其提供的系统服务、进程类型和对硬件适应能力方面均有所不同，而且在它们之间存在着一定的兼容性。BCC1和BCC2只支持基础进程，不支持事件机制；ECC1和ECC2支持基础进程和扩展进程，并且支持事件机制；BCC1和ECC1支持每个优先级只有一个进程，BCC2和ECC2支持每个优先级可以有多个进程，每个进程可以有多个激活请求。开发人员可以根据需要选择合适的符合级别来实现一个完全符合OSEK规范的操作系统，也可以开发支持全部符合级别的系统并提供配置选项，供用户选择使用。

## D. AUTOSAR标准

2003年行业内的几大巨头（包括BMW, Bosch, Continental, DaimlerChrysler, Volkswagen, Siemens VDO）联合建立了AUTOSAR联盟，目的是一起开发并建立一套真正的开放的汽车电子电器架构（也就是我们现在所说的AUTOSAR标准或者AUTOSAR架构，AUTOSAR的全称是AUTomotive Open System ARchitecture），随着多年的发展，越来越多的行业内的公司加入到了AUTOSAR联盟中，这其中有OEM（汽车整车厂），Tier1（汽车零部件供应商），芯片制造商以及工具制造商，AUTOSAR构架/标准也成为了汽车E/E设计的发展方向。

AUTOSAR架构和标准的目标是：

- 满足未来汽车的需求，例如可用性和安全性、软件升级更新需求、可维护性等
- 增加软件的灵活性和可扩展性来实现软件的集成和整合
- 实现商用现成的跨产品线的软件硬件
- 控制产品和流程的复杂度和风险
- 优化成本

![img](https://upload-images.jianshu.io/upload_images/7412056-54d3d42814266e40?imageMogr2/auto-orient/strip|imageView2/2/w/876/format/webp)

### 1. AUTOSAR架构的特点

- **模块化和可配置性**：定义了一套汽车ECU软件构架，将不依赖硬件的软件模块和依赖硬件的软件模块分别封装起来，从而可以让ECU可以集成由不同供应商提供的软件模块，增加了功能的重用性，提高了软件质量。软件可以根据不同的ECU功能需求和资源情况进行灵活配置。
- **接口标准化**：定义了一系列的标准API来实现软件的分层化。
- **提出了RTE的概念**：RTE全称是Runtime Environment，采用RTE实现了ECU内部和ECU之间的节点通讯，RTE处于功能软件模块和基础软件模块之间，使得软件集成更加容易。
- **具有标准的测试规范** ：针对功能和通讯总线制定了标准的测试规范，测是规范涵盖的范围包括对于AUTOSAR的应用兼容性（例如RTE的需求，软件服务行为需求和库等）和总线兼容性（总线处理行为和总线协议等），它的目标是建立标准的测试规范从而减少测试工作量和成本。

### 2. AUTOSAR标准核心内容

- ECU软件构架；
- 软件组件（software components）
- 虚拟功能总线（Virtual Functional Bus）
- AUTOSAR设计方法（Methodology）

### 3. OSEK/VDX和AUTOSAR关系

AUTOSAR与OSEK二者都是汽车电子软件的标准。OSEK/VDX是基于ECU开发的操作系统标准，AUTOSAR基于整体汽车电子开发的功能标准。AUTOSAR中规定的操作系统标准就是基于OSEK/VDX，通信和网络管理虽然和OSEK有区别，但是有继承性的。可以认为，AUTOSAR是基于OSEK/VDX发展出来的，OSEK/VDX被AUTOSAR标准软件架构所包含。

![img](https://upload-images.jianshu.io/upload_images/7412056-7d8da5896031fea2?imageMogr2/auto-orient/strip|imageView2/2/w/549/format/webp)

### 4. 市场上符合OSEK/VDX规范的OS产品

- FreeOSEK（https://github.com/ciaa/Firmware）和OpenOSEK（https://github.com/parai/OpenOSEK）是两个开源的OSEK/VDX操作系统，目前都在github上。
- ProOSEK是德国的3soft公司推出的全世界最早的OSEK/VDX操作系统(1997)，为BMW、VM/Audi、DaimlerChrysler提供了基于OSEK的软件开发平台。
- Freescale公司开发的OSEKTurbo是目前市场上实现OSEK/VDX标准中，使用最为广泛的实时操作系统之一，在业界居领先地位，完全满足最新的OSEK/VDX开放系统的标准，支持8、16、32位微处理器，在稳定性和软件质量方面表现出色，当然现在属于NXP。
- Nucleus OSEK是Accelerated Technology Embedded System公司基于开源的Nucleus PLUS操作系统的基础之上实现的，它实现了OSEK/VDX标准的V2.2R1版本，提供了完全的OSEK/VDX认证。
- Embedded Office开发的OSEK Extension for uC/OS II基于开源的uC/OS II操作系统，通过了BCC1、ECC1、CCCA、CCCB的官方认证。
- OSEKWorks是Wind River公司在其VxWorks的基础之上根据OSEK/VDX标准扩展开发的，具有VxWorks的优良特性。
- osCAN是德国的Vector公司开发的具有CANopen协议栈的OSEK操作系统，可以结合Vector公司任意通信协议，支持多版本的CAN协议，具有多种特殊功能，例如运行过程中的堆栈管理，多种堆栈优化方法，内部跟踪、模板生成器、组件管理器等。
- RTA-OSEK是LiveDevices公司开发的，是全球第一个完整实现OSEK所有一致类的RTOS。ERCOSEK是BOSCH公司在其发动机管理系统中使用的实时操作系统，由ETAS公司开发。LiveDevices与ETAS在2007年合并。
- R-OSEK是由韩国电子与电信研究院(ETRI)开发的OSEK/VDX标准的RTOS，ETRI从2006年投资了367万美元用于开发ROSEK，并于2009年5月份通过了OSEK/VDX的认证。
- DeltaOSEK是中国北京科银京成技术有限公司为汽车电子的控制类应用所开发的、符合OSEK/VDX标准的嵌入式操作系统，提供标准的OS及COM功能部件的应用编程接口。它的最新版本在MPC555/MPC5554的平台上通过了OSEK/VDX测试集的全面测试，符合OSEK/VDX标准，于2009年3月获得了OSEK/VDX认证机构的认可。
- SmartOSEK OS是由浙江大学ESE工程中心开发的符合OSEK/VDX标准的嵌入式实时操作系统，在2005年通过了国际OSEK/VDX组织的官方认证。SmartOSEK OS支持多种国际主流处理器，满足不同的硬件需求，具有静态配置、微内核和实时性等优点，实现可抢占式内核以及多种实时调度机制，适用于实时性要求较高的汽车电子产品。

## E. 其它

> 1. https://blog.csdn.net/lianyunyouyou/article/details/109686387
> 2. https://leon1741.blog.csdn.net/article/details/105847992
> 3. https://piembsystech.com/osek/

# Specification of Operating System - AUTOSAR

## Functional specification

###  1. Core OS

#### Background & Rationale

For these reasons the core functionality of the **AUTOSAR OS** shall be based upon the **OSEK OS**. In particular OSEK OS provides the following features to support concepts in AUTOSAR:

- fixed priority-based scheduling 
- facilities for handling interrupts 
- only interrupts with higher priority than tasks 
- some protection against incorrect use of OS services 
- a startup interface through `StartOS()` and the `StartupHook()` 
- a shutdown interface through `ShutdownOS()` and the `ShutdownHook()`

#### Requirements

- The Operating System module shall provide an API that is backward compatible with the OSEK OS API


### 2. Software Free Running Timer

### 3. Schedule Tables

#### Background & Rationale





























